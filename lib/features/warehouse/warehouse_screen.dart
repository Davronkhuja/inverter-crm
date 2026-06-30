import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/enums.dart';
import '../../core/theme/app_icons.dart';
import '../../core/theme/app_icons_context.dart';
import '../../core/utils/enum_localizations.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/inverter.dart';
import '../../state/inverter_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/status_badge.dart';
import '../detail/detail_screen.dart';

class WarehouseScreen extends StatelessWidget {
  const WarehouseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final icons = context.icons;
    final provider = context.watch<InverterProvider>();

    if (provider.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    final replaced = provider.all.where((inv) => inv.replaced).toList();

    if (replaced.isEmpty) {
      return _buildEmpty(context, l10n, theme, scheme, icons);
    }

    // Group by oldInverterLocation
    final grouped = <OldInverterLocation, List<Inverter>>{};
    for (final inv in replaced) {
      grouped.putIfAbsent(inv.oldInverterLocation, () => []).add(inv);
    }
    // Sort groups by location ordinal for stable order
    final groupEntries = OldInverterLocation.values
        .where((loc) => grouped.containsKey(loc))
        .map((loc) => MapEntry(loc, grouped[loc]!))
        .toList();

    // Build flat sliver list: section header + items per group
    final sliverItems = <Widget>[];
    for (final entry in groupEntries) {
      final loc = entry.key;
      final items = entry.value;
      sliverItems.add(_GroupHeader(
        icon: loc.icon,
        label: loc.l10n(l10n),
        count: items.length,
        color: _locationColor(loc, scheme),
      ));
      for (final inv in items) {
        sliverItems.add(_ReplacedCard(
          inverter: inv,
          icons: icons,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => DetailScreen(inverterId: inv.id),
            ),
          ),
        ));
      }
    }

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            floating: true,
            titleSpacing: 20,
            title: Text(l10n.warehouseTitle),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(36),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                child: Row(
                  children: [
                    Icon(
                      icons.statusReplaced,
                      size: 14,
                      color: scheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${replaced.length} ${l10n.cardStatusReplaced.toLowerCase()}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            sliver: SliverList.list(children: sliverItems),
          ),
        ],
      ),
    );
  }

  Color _locationColor(OldInverterLocation loc, ColorScheme scheme) {
    switch (loc) {
      case OldInverterLocation.warehouse:
        return scheme.primary;
      case OldInverterLocation.serviceCenter:
        return scheme.error;
      case OldInverterLocation.customerSite:
        return scheme.tertiary;
      case OldInverterLocation.returnedToFactory:
        return scheme.secondary;
      case OldInverterLocation.scrapped:
        return scheme.onSurfaceVariant;
      case OldInverterLocation.other:
        return scheme.outline;
    }
  }

  Widget _buildEmpty(
    BuildContext context,
    AppLocalizations l10n,
    ThemeData theme,
    ColorScheme scheme,
    AppIconSet icons,
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
                        color: scheme.surfaceContainerHighest.withValues(
                          alpha: 0.5,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        icons.warehouseStock,
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

class _GroupHeader extends StatelessWidget {
  final IconData icon;
  final String label;
  final int count;
  final Color color;

  const _GroupHeader({
    required this.icon,
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 15, color: color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              count.toString(),
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReplacedCard extends StatelessWidget {
  final Inverter inverter;
  final AppIconSet icons;
  final VoidCallback onTap;

  const _ReplacedCard({
    required this.inverter,
    required this.icons,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final inv = inverter;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Card(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        scheme.error.withValues(alpha: isDark ? 0.28 : 0.16),
                        scheme.error.withValues(alpha: isDark ? 0.10 : 0.04),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: scheme.error.withValues(alpha: 0.20),
                    ),
                  ),
                  child: Icon(icons.unit, color: scheme.error, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              inv.model.isEmpty ? l10n.cardUnknownModel : inv.model,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          StatusBadge(
                            label: l10n.cardStatusReplaced,
                            color: scheme.error,
                            icon: icons.statusReplaced,
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        inv.asn,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: scheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      _row(theme, scheme, icons.client,
                          inv.clientName.isEmpty ? '—' : inv.clientName),
                      const SizedBox(height: 2),
                      _row(theme, scheme, icons.location, inv.locationLabel),
                      if (inv.newAsn != null && inv.newAsn!.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        _row(theme, scheme, icons.swap,
                            '→ ${inv.newAsn}'),
                      ],
                      const SizedBox(height: 6),
                      StatusBadge(
                        label: l10n.cardInstalledOn(
                          Formatters.date(inv.installationDate),
                        ),
                        color: scheme.onSurfaceVariant,
                        icon: icons.calendar,
                      ),
                    ],
                  ),
                ),
                Icon(
                  icons.chevronRight,
                  color: scheme.onSurfaceVariant.withValues(alpha: 0.6),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _row(ThemeData theme, ColorScheme scheme, IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 13, color: scheme.onSurfaceVariant),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}
