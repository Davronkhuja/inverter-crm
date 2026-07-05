import 'package:flutter/material.dart';

import '../../../core/constants/enums.dart';
import '../../../core/theme/app_icons_context.dart';
import '../../../core/utils/enum_localizations.dart';
import '../../../core/utils/formatters.dart';
import '../../../l10n/app_localizations.dart';
import '../../../state/inverter_filter.dart';

extension SortByL10n on SortBy {
  String label(AppLocalizations l) {
    switch (this) {
      case SortBy.installDate: return l.sortByDate;
      case SortBy.saleDate:    return l.fieldSaleDate;
      case SortBy.model:       return l.sortByModel;
      case SortBy.client:      return l.sortByClient;
      case SortBy.orderNo:     return l.sortByOrderNo;
    }
  }
}

/// Нижний лист с фильтрами дашборда: статус замены, тип неисправности,
/// модель, диапазоны дат установки и продажи (ТЗ §2).
class FilterSheet extends StatefulWidget {
  final InverterFilter initial;
  final List<String> models;

  const FilterSheet({super.key, required this.initial, required this.models});

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  late InverterFilter _draft = widget.initial;

  Future<void> _pickRange({required bool installed}) async {
    final now = DateTime.now();
    final initialRange = installed
        ? (_draft.installedFrom != null && _draft.installedTo != null
              ? DateTimeRange(
                  start: _draft.installedFrom!,
                  end: _draft.installedTo!,
                )
              : null)
        : (_draft.soldFrom != null && _draft.soldTo != null
              ? DateTimeRange(start: _draft.soldFrom!, end: _draft.soldTo!)
              : null);

    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2010),
      lastDate: DateTime(now.year + 1, 12, 31),
      initialDateRange: initialRange,
    );
    if (range == null) return;
    setState(() {
      if (installed) {
        _draft = _draft.copyWith(
          installedFrom: range.start,
          installedTo: range.end,
        );
      } else {
        _draft = _draft.copyWith(soldFrom: range.start, soldTo: range.end);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final icons = context.icons;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 12,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: scheme.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Text(
                    l10n.filterTitle,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: () => setState(
                      () => _draft = InverterFilter(
                        query: _draft.query,
                        replaced: ReplacedFilter.notReplaced,
                      ),
                    ),
                    icon: const Icon(Icons.restart_alt_rounded, size: 18),
                    label: Text(l10n.filterReset),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              _label(theme, l10n.sortBy),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: SortBy.values.map((s) {
                        final selected = _draft.sortBy == s;
                        return ChoiceChip(
                          label: Text(s.label(l10n)),
                          selected: selected,
                          onSelected: (_) =>
                              setState(() => _draft = _draft.copyWith(sortBy: s)),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _dirChip(l10n.sortAscending, SortDir.asc, theme, scheme),
                  const SizedBox(width: 8),
                  _dirChip(l10n.sortDescending, SortDir.desc, theme, scheme),
                ],
              ),
              const SizedBox(height: 18),

              _label(theme, l10n.filterReplacedOnly),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: ReplacedFilter.values.map((r) {
                  final selected = _draft.replaced == r;
                  return ChoiceChip(
                    label: Text(r.l10n(l10n)),
                    selected: selected,
                    onSelected: (_) =>
                        setState(() => _draft = _draft.copyWith(replaced: r)),
                  );
                }).toList(),
              ),
              const SizedBox(height: 18),

              _label(theme, l10n.filterFaultType),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: FaultType.values.map((f) {
                  final selected = _draft.faultType == f;
                  return ChoiceChip(
                    label: Text(f.l10n(l10n)),
                    selected: selected,
                    onSelected: (_) => setState(
                      () => _draft = selected
                          ? _draft.copyWith(clearFaultType: true)
                          : _draft.copyWith(faultType: f),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 18),

              if (widget.models.isNotEmpty) ...[
                _label(theme, l10n.filterModel),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: widget.models.map((m) {
                    final selected = _draft.model == m;
                    return ChoiceChip(
                      label: Text(m),
                      selected: selected,
                      onSelected: (_) => setState(
                        () => _draft = selected
                            ? _draft.copyWith(clearModel: true)
                            : _draft.copyWith(model: m),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 18),
              ],

              _label(theme, l10n.fieldInstallationDate),
              const SizedBox(height: 8),
              _dateRangeTile(
                theme,
                scheme,
                icons.calendar,
                icons.clear,
                from: _draft.installedFrom,
                to: _draft.installedTo,
                onTap: () => _pickRange(installed: true),
                onClear: _draft.installedFrom == null
                    ? null
                    : () => setState(
                        () => _draft = _draft.copyWith(clearInstalled: true),
                      ),
              ),
              const SizedBox(height: 18),

              _label(theme, l10n.fieldSaleDate),
              const SizedBox(height: 8),
              _dateRangeTile(
                theme,
                scheme,
                icons.calendar,
                icons.clear,
                from: _draft.soldFrom,
                to: _draft.soldTo,
                onTap: () => _pickRange(installed: false),
                onClear: _draft.soldFrom == null
                    ? null
                    : () => setState(
                        () => _draft = _draft.copyWith(clearSold: true),
                      ),
              ),
              const SizedBox(height: 24),

              FilledButton(
                onPressed: () => Navigator.of(context).pop(_draft),
                child: Text(l10n.filterApply),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dirChip(
    String label,
    SortDir dir,
    ThemeData theme,
    ColorScheme scheme,
  ) {
    final selected = _draft.sortDir == dir;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => setState(() => _draft = _draft.copyWith(sortDir: dir)),
    );
  }

  Widget _label(ThemeData theme, String text) => Text(
    text,
    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
  );

  Widget _dateRangeTile(
    ThemeData theme,
    ColorScheme scheme,
    IconData calendarIcon,
    IconData clearIcon, {
    required DateTime? from,
    required DateTime? to,
    required VoidCallback onTap,
    required VoidCallback? onClear,
  }) {
    final hasRange = from != null && to != null;
    return Material(
      color: scheme.surfaceContainerHighest.withValues(alpha: 0.4),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Row(
            children: [
              Icon(calendarIcon, size: 18, color: scheme.primary),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  hasRange
                      ? '${Formatters.date(from)}  –  ${Formatters.date(to)}'
                      : AppLocalizations.of(context)!.dateSelect,
                  style: theme.textTheme.bodyLarge,
                ),
              ),
              if (onClear != null)
                IconButton(
                  visualDensity: VisualDensity.compact,
                  icon: Icon(clearIcon, size: 18),
                  onPressed: onClear,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
