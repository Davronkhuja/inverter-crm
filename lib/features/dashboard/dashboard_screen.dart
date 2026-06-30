import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_icons_context.dart';
import '../../data/models/inverter.dart';
import '../../l10n/app_localizations.dart';
import '../../state/inverter_filter.dart';
import '../../state/inverter_provider.dart';
import '../detail/detail_screen.dart';
import '../form/inverter_form_screen.dart';
import 'widgets/filter_sheet.dart';
import 'widgets/inverter_card.dart';

/// Главный экран CRM: статистика, поиск, фильтры и список инверторов.
/// Переключатель темы и экспорт перенесены в Account — здесь только
/// рабочий процесс с данными.
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final icons = context.icons;
    final provider = context.watch<InverterProvider>();

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
                title: _AppTitle(title: l10n.appTitle, icon: icons.brand),
              ),

              // Статистика — мягкие gradient-карточки.
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 14),
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
                            prefixIcon: Icon(icons.search),
                            suffixIcon: provider.filter.query.isEmpty
                                ? null
                                : IconButton(
                                    icon: Icon(icons.clear),
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
                        icon: icons.filter,
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
        icon: Icon(icons.add),
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
    final icons = context.icons;
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
            icon: icons.fault,
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
            icon: filtered ? icons.search : icons.inventory,
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
  final IconData icon;
  const _AppTitle({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [scheme.primary, scheme.primary.withValues(alpha: 0.65)],
            ),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: scheme.primary.withValues(alpha: 0.35),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 19),
        ),
        const SizedBox(width: 11),
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
    final icons = context.icons;
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            value: provider.totalCount.toString(),
            label: l10n.statTotalUnits,
            icon: icons.statTotalUnits,
            color: scheme.primary,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            value: provider.replacedCount.toString(),
            label: l10n.statReplaced,
            icon: icons.statReplaced,
            color: scheme.error,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            value: provider.activeFaultCount.toString(),
            label: l10n.statOpenFaults,
            icon: icons.statFaults,
            color: scheme.tertiary,
          ),
        ),
      ],
    );
  }
}

/// Карточка статистики с мягким градиентным фоном в цвете акцента —
/// современный, "лёгкий" вид вместо плоской заливки.
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
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: isDark ? 0.22 : 0.14),
            color.withValues(alpha: isDark ? 0.06 : 0.03),
          ],
        ),
        border: Border.all(color: color.withValues(alpha: isDark ? 0.3 : 0.16)),
      ),
      padding: const EdgeInsets.fromLTRB(14, 14, 10, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: color.withValues(alpha: isDark ? 0.28 : 0.16),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(icon, color: color, size: 17),
          ),
          const SizedBox(height: 11),
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
    );
  }
}

class _FilterButton extends StatelessWidget {
  final IconData icon;
  final int count;
  final VoidCallback onTap;
  const _FilterButton({
    required this.icon,
    required this.count,
    required this.onTap,
  });

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
              Icon(icon, color: active ? Colors.white : scheme.onSurfaceVariant),
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
