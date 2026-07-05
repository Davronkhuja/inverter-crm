import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/enums.dart';
import '../../core/theme/app_icons_context.dart';
import '../../core/utils/enum_localizations.dart';
import '../../data/models/inverter.dart';
import '../../l10n/app_localizations.dart';
import '../../state/inverter_provider.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final provider = context.watch<InverterProvider>();

    if (provider.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    final all = provider.all;

    if (all.isEmpty) {
      return _buildEmpty(context, l10n, theme, scheme);
    }

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            floating: true,
            titleSpacing: 20,
            title: Text(l10n.analyticsTitle),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
            sliver: SliverList.list(
              children: [
                _StatusChart(all: all, l10n: l10n, theme: theme, scheme: scheme),
                const SizedBox(height: 20),
                _BarChart(
                  title: l10n.analyticsByFaultType,
                  entries: _faultEntries(all, l10n),
                  theme: theme,
                  scheme: scheme,
                  color: scheme.tertiary,
                ),
                const SizedBox(height: 20),
                _BarChart(
                  title: l10n.analyticsByModel,
                  entries: _modelEntries(all),
                  theme: theme,
                  scheme: scheme,
                  color: scheme.primary,
                ),
                const SizedBox(height: 20),
                _BarChart(
                  title: l10n.analyticsByStatus,
                  entries: _locationEntries(all, l10n),
                  theme: theme,
                  scheme: scheme,
                  color: scheme.secondary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<_Entry> _faultEntries(List<Inverter> all, AppLocalizations l) {
    final counts = <FaultType, int>{};
    for (final inv in all) {
      if (inv.faultType != FaultType.none) {
        counts[inv.faultType] = (counts[inv.faultType] ?? 0) + 1;
      }
    }
    final sorted = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted.map((e) => _Entry(e.key.l10n(l), e.value)).toList();
  }

  List<_Entry> _modelEntries(List<Inverter> all) {
    final counts = <String, int>{};
    for (final inv in all) {
      final m = inv.model.trim();
      if (m.isNotEmpty) counts[m] = (counts[m] ?? 0) + 1;
    }
    final sorted = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted.take(8).map((e) => _Entry(e.key, e.value)).toList();
  }

  List<_Entry> _locationEntries(List<Inverter> all, AppLocalizations l) {
    final counts = <OldInverterLocation, int>{};
    for (final inv in all) {
      if (inv.replaced) {
        counts[inv.oldInverterLocation] =
            (counts[inv.oldInverterLocation] ?? 0) + 1;
      }
    }
    final sorted = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted.map((e) => _Entry(e.key.l10n(l), e.value)).toList();
  }

  Widget _buildEmpty(
    BuildContext context,
    AppLocalizations l10n,
    ThemeData theme,
    ColorScheme scheme,
  ) {
    final icons = context.icons;
    return SafeArea(
      child: Column(
        children: [
          AppBar(title: Text(l10n.analyticsTitle)),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icons.navAnalytics,
                    size: 56,
                    color: scheme.onSurfaceVariant.withValues(alpha: 0.4),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.analyticsNoData,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Entry {
  final String label;
  final int count;
  const _Entry(this.label, this.count);
}

// ─── Status donut-style summary ──────────────────────────────────────────────

class _StatusChart extends StatelessWidget {
  final List<Inverter> all;
  final AppLocalizations l10n;
  final ThemeData theme;
  final ColorScheme scheme;

  const _StatusChart({
    required this.all,
    required this.l10n,
    required this.theme,
    required this.scheme,
  });

  @override
  Widget build(BuildContext context) {
    final total = all.length;
    final replaced = all.where((i) => i.replaced).length;
    final active = total - replaced;
    final faulted = all.where((i) => !i.replaced && i.faultType != FaultType.none).length;

    return _Card(
      title: l10n.analyticsByStatus,
      theme: theme,
      scheme: scheme,
      child: Row(
        children: [
          _StatTile(
            label: l10n.statTotalUnits,
            count: total,
            color: scheme.primary,
            theme: theme,
          ),
          _StatTile(
            label: l10n.cardStatusActive,
            count: active,
            color: const Color(0xFF2E9E5B),
            theme: theme,
          ),
          _StatTile(
            label: l10n.cardStatusReplaced,
            count: replaced,
            color: scheme.error,
            theme: theme,
          ),
          _StatTile(
            label: l10n.statOpenFaults,
            count: faulted,
            color: scheme.tertiary,
            theme: theme,
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  final ThemeData theme;

  const _StatTile({
    required this.label,
    required this.count,
    required this.color,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            count.toString(),
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: color,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Generic horizontal bar chart ────────────────────────────────────────────

class _BarChart extends StatelessWidget {
  final String title;
  final List<_Entry> entries;
  final ThemeData theme;
  final ColorScheme scheme;
  final Color color;

  const _BarChart({
    required this.title,
    required this.entries,
    required this.theme,
    required this.scheme,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (entries.isEmpty) {
      return _Card(
        title: title,
        theme: theme,
        scheme: scheme,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              l10n.analyticsNoData,
              style: theme.textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
      );
    }

    final max = entries.map((e) => e.count).reduce((a, b) => a > b ? a : b);

    return _Card(
      title: title,
      theme: theme,
      scheme: scheme,
      child: Column(
        children: entries.map((e) {
          final fraction = max == 0 ? 0.0 : e.count / max;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                SizedBox(
                  width: 110,
                  child: Text(
                    e.label,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: scheme.onSurface,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        height: 22,
                        decoration: BoxDecoration(
                          color: scheme.surfaceContainerHighest
                              .withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: fraction.clamp(0.02, 1.0),
                        child: Container(
                          height: 22,
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.85),
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 28,
                  child: Text(
                    e.count.toString(),
                    textAlign: TextAlign.end,
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─── Shared card wrapper ──────────────────────────────────────────────────────

class _Card extends StatelessWidget {
  final String title;
  final Widget child;
  final ThemeData theme;
  final ColorScheme scheme;

  const _Card({
    required this.title,
    required this.child,
    required this.theme,
    required this.scheme,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: scheme.primary,
              ),
            ),
            const SizedBox(height: 14),
            child,
          ],
        ),
      ),
    );
  }
}
