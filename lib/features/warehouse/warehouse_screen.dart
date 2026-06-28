import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/enums.dart';
import '../../data/models/inverter.dart';
import '../../state/inverter_provider.dart';
import '../../l10n/app_localizations.dart';
import '../detail/detail_screen.dart';

/// Экран склада: показывает только инверторы, которые были заменены —
/// это единственный способ, которым unit попадает на склад/к сервису/
/// возвращается на завод и т.д. Склад не принимает прямого ввода новых
/// данных, это чисто отчётный экран на основе поля "старое местонахождение"
/// у замененных записей.
class WarehouseScreen extends StatelessWidget {
  const WarehouseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final provider = context.watch<InverterProvider>();

    if (provider.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Только замененные записи — у них заполнено oldInverterLocation.
    final replaced = provider.all.where((inv) => inv.replaced).toList();
    if (replaced.isEmpty) {
      return _buildEmpty(context, l10n, theme, scheme);
    }

    final inWarehouse = replaced
        .where((i) => i.oldInverterLocation == OldInverterLocation.warehouse)
        .toList();
    final atCustomers = replaced
        .where((i) => i.oldInverterLocation == OldInverterLocation.customerSite)
        .toList();
    final atService = replaced
        .where((i) => i.oldInverterLocation == OldInverterLocation.serviceCenter)
        .toList();

    final byModel = <String, List<Inverter>>{};
    for (final inv in inWarehouse) {
      final key = inv.model.trim().isEmpty ? '—' : inv.model.trim();
      byModel.putIfAbsent(key, () => []).add(inv);
    }
    final modelEntries = byModel.entries.toList()
      ..sort((a, b) => b.value.length.compareTo(a.value.length));

    final byLocation = <String, List<Inverter>>{};
    for (final inv in inWarehouse) {
      final key = inv.locationLabel;
      byLocation.putIfAbsent(key, () => []).add(inv);
    }
    final locationEntries = byLocation.entries.toList()
      ..sort((a, b) => b.value.length.compareTo(a.value.length));

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            floating: true,
            titleSpacing: 20,
            title: Text(l10n.warehouseTitle),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
            sliver: SliverToBoxAdapter(
              child: Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      value: inWarehouse.length.toString(),
                      label: l10n.warehouseTotalInStock,
                      icon: Icons.warehouse_outlined,
                      color: scheme.primary,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _StatCard(
                      value: atCustomers.length.toString(),
                      label: l10n.warehouseAtCustomers,
                      icon: Icons.location_on_outlined,
                      color: scheme.tertiary,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _StatCard(
                      value: atService.length.toString(),
                      label: l10n.warehouseAtService,
                      icon: Icons.build_circle_outlined,
                      color: scheme.error,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            sliver: SliverToBoxAdapter(
              child: _SectionLabel(l10n.warehouseByModel),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
            sliver: SliverList.separated(
              itemCount: modelEntries.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (_, i) {
                final entry = modelEntries[i];
                return _BreakdownTile(
                  icon: Icons.memory_rounded,
                  label: entry.key,
                  count: entry.value.length,
                  total: inWarehouse.length,
                  color: scheme.primary,
                );
              },
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            sliver: SliverToBoxAdapter(
              child: _SectionLabel(l10n.warehouseByLocation),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            sliver: SliverList.separated(
              itemCount: locationEntries.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (_, i) {
                final entry = locationEntries[i];
                return _BreakdownTile(
                  icon: Icons.place_outlined,
                  label: entry.key,
                  count: entry.value.length,
                  total: inWarehouse.length,
                  color: scheme.tertiary,
                  onTap: entry.value.length == 1
                      ? () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => DetailScreen(
                        inverterId: entry.value.first.id,
                      ),
                    ),
                  )
                      : null,
                );
              },
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }

  Widget _buildEmpty(
      BuildContext context,
      AppLocalizations l10n,
      ThemeData theme,
      ColorScheme scheme,
      ) {
    return SafeArea(
      child: Column(
        children: [
          AppBar(title: Text(l10n.warehouseTitle)),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 76,
                      height: 76,
                      decoration: BoxDecoration(
                        color: scheme.surfaceContainerHighest.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.warehouse_outlined,
                        size: 34,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      l10n.warehouseEmpty,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.w700,
        color: Theme.of(context).colorScheme.primary,
        letterSpacing: 0.2,
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(13, 13, 10, 13),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 10),
            Text(
              value,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 1),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BreakdownTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final int count;
  final int total;
  final Color color;
  final VoidCallback? onTap;

  const _BreakdownTile({
    required this.icon,
    required this.label,
    required this.count,
    required this.total,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final ratio = total == 0 ? 0.0 : count / total;
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: 18, color: color),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    count.toString(),
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: scheme.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: ratio,
                  minHeight: 6,
                  backgroundColor: scheme.surfaceContainerHighest.withValues(alpha: 0.5),
                  valueColor: AlwaysStoppedAnimation(color),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}