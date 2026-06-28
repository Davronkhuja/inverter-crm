import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/inverter.dart';
import '../../l10n/app_localizations.dart';
import '../../state/inverter_provider.dart';
import '../../state/inverter_filter.dart';
import '../../state/settings_provider.dart';
import '../detail/detail_screen.dart';
import '../export/export_service.dart';
import '../form/inverter_form_screen.dart';
import 'widgets/filter_sheet.dart';
import 'widgets/inverter_card.dart';

/// Главный экран CRM: статистика, поиск, фильтры и список инверторов.
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _openFilters(InverterProvider provider) async {
    final result = await showModalBottomSheet<InverterFilter>(
      context: context,
      isScrollControlled: true,
      showDragHandle: false,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) =>
          FilterSheet(initial: provider.filter, models: provider.models),
    );
    if (result != null) provider.setFilter(result);
  }

  Future<void> _openDetail(Inverter inverter) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => DetailScreen(inverterId: inverter.id)),
    );
  }

  Future<void> _addNew() async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const InverterFormScreen()));
  }

  Future<void> _export(InverterProvider provider, ExportFormat format) async {
    final l10n = AppLocalizations.of(context)!;
    final visible = provider.visible;
    if (visible.isEmpty) {
      _toast(l10n.exportNothing);
      return;
    }
    try {
      await ExportService().export(visible, format);
    } catch (e) {
      _toast(l10n.exportFailed(e.toString()));
    }
  }

  void _toast(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final provider = context.watch<InverterProvider>();
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: provider.load,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                floating: true,
                titleSpacing: 20,
                title: _AppTitle(title: l10n.appTitle),
                actions: [
                  IconButton(
                    tooltip: l10n.toggleTheme,
                    icon: Icon(
                      settings.themeMode == ThemeMode.dark
                          ? Icons.light_mode_outlined
                          : Icons.dark_mode_outlined,
                    ),
                    onPressed: () {
                      final isDark = settings.themeMode == ThemeMode.dark;
                      settings.setThemeMode(
                        isDark ? ThemeMode.light : ThemeMode.dark,
                      );
                    },
                  ),
                  PopupMenuButton<ExportFormat>(
                    tooltip: l10n.exportTooltip,
                    icon: const Icon(Icons.ios_share_outlined),
                    onSelected: (f) => _export(provider, f),
                    itemBuilder: (_) => [
                      PopupMenuItem(
                        value: ExportFormat.excel,
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.table_chart_outlined),
                          title: Text(l10n.exportToExcel),
                        ),
                      ),
                      PopupMenuItem(
                        value: ExportFormat.pdf,
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.picture_as_pdf_outlined),
                          title: Text(l10n.exportToPdf),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 4),
                ],
              ),

              // Статистика.
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
                  child: _StatsRow(provider: provider, l10n: l10n),
                ),
              ),

              // Поиск + фильтр.
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          onChanged: provider.setQuery,
                          textInputAction: TextInputAction.search,
                          decoration: InputDecoration(
                            hintText: l10n.searchHint,
                            prefixIcon: const Icon(Icons.search_rounded),
                            suffixIcon: provider.filter.query.isEmpty
                                ? null
                                : IconButton(
                                    icon: const Icon(Icons.close_rounded),
                                    onPressed: () {
                                      _searchController.clear();
                                      provider.setQuery('');
                                    },
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      _FilterButton(
                        count: provider.filter.activeCount,
                        onTap: () => _openFilters(provider),
                      ),
                    ],
                  ),
                ),
              ),

              // Активные фильтры — подпись + сброс.
              if (provider.filter.hasActiveFilters)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 4),
                    child: Row(
                      children: [
                        Text(
                          l10n.shownOfTotal(
                            provider.visible.length,
                            provider.totalCount,
                          ),
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: provider.clearFilters,
                          child: Text(l10n.clearFilters),
                        ),
                      ],
                    ),
                  ),
                ),

              // Контент: loading / error / empty / list.
              ..._buildBody(provider, theme, scheme, l10n),

              const SliverToBoxAdapter(child: SizedBox(height: 96)),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addNew,
        icon: const Icon(Icons.add_rounded),
        label: Text(l10n.addInverter),
      ),
    );
  }

  List<Widget> _buildBody(
    InverterProvider provider,
    ThemeData theme,
    ColorScheme scheme,
    AppLocalizations l10n,
  ) {
    if (provider.loading) {
      return [
        const SliverFillRemaining(
          hasScrollBody: false,
          child: Center(child: CircularProgressIndicator()),
        ),
      ];
    }
    if (provider.error != null) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: _EmptyState(
            icon: Icons.error_outline_rounded,
            title: l10n.errorTitle,
            message: provider.error!,
            actionLabel: l10n.retry,
            onAction: provider.load,
          ),
        ),
      ];
    }
    final items = provider.visible;
    if (items.isEmpty) {
      final filtered =
          provider.filter.hasActiveFilters || provider.filter.query.isNotEmpty;
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: _EmptyState(
            icon: filtered ? Icons.search_off_rounded : Icons.inbox_outlined,
            title: filtered ? l10n.emptyNoMatchesTitle : l10n.emptyNoDataTitle,
            message: filtered
                ? l10n.emptyNoMatchesMessage
                : l10n.emptyNoDataMessage,
            actionLabel: filtered ? l10n.clearFilters : l10n.addInverter,
            onAction: filtered ? provider.clearFilters : _addNew,
          ),
        ),
      ];
    }
    return [
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(20, 6, 20, 0),
        sliver: SliverList.separated(
          itemCount: items.length,
          separatorBuilder: (_, _) => const SizedBox(height: 10),
          itemBuilder: (_, i) => InverterCard(
            inverter: items[i],
            onTap: () => _openDetail(items[i]),
          ),
        ),
      ),
    ];
  }
}

class _AppTitle extends StatelessWidget {
  final String title;
  const _AppTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: scheme.primary,
            borderRadius: BorderRadius.circular(9),
          ),
          child: const Icon(Icons.bolt_rounded, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 10),
        Text(title),
      ],
    );
  }
}

class _StatsRow extends StatelessWidget {
  final InverterProvider provider;
  final AppLocalizations l10n;
  const _StatsRow({required this.provider, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            value: provider.totalCount.toString(),
            label: l10n.statTotalUnits,
            icon: Icons.solar_power_outlined,
            color: scheme.primary,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            value: provider.replacedCount.toString(),
            label: l10n.statReplaced,
            icon: Icons.swap_horiz_rounded,
            color: scheme.error,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            value: provider.activeFaultCount.toString(),
            label: l10n.statOpenFaults,
            icon: Icons.warning_amber_rounded,
            color: scheme.tertiary,
          ),
        ),
      ],
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

class _FilterButton extends StatelessWidget {
  final int count;
  final VoidCallback onTap;
  const _FilterButton({required this.count, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final active = count > 0;
    return Material(
      color: active
          ? scheme.primary
          : scheme.surfaceContainerHighest.withValues(alpha: 0.5),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          height: 52,
          constraints: const BoxConstraints(minWidth: 52),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.tune_rounded,
                color: active ? Colors.white : scheme.onSurfaceVariant,
              ),
              if (active) ...[
                const SizedBox(width: 7),
                Text(
                  count.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String actionLabel;
  final VoidCallback onAction;

  const _EmptyState({
    required this.icon,
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Padding(
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
            child: Icon(icon, size: 34, color: scheme.onSurfaceVariant),
          ),
          const SizedBox(height: 18),
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            message,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 20),
          FilledButton.tonal(onPressed: onAction, child: Text(actionLabel)),
        ],
      ),
    );
  }
}
