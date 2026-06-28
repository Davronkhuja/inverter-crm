import 'package:flutter/material.dart';

import '../../../core/constants/enums.dart';
import '../../../core/utils/enum_localizations.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/inverter.dart';
import '../../../l10n/app_localizations.dart';
import '../../../widgets/status_badge.dart';

/// Карточка одной записи инвертора в списке дашборда.
/// Показывает модель, ASN, клиента, локацию и статусные бейджи.
class InverterCard extends StatelessWidget {
  final Inverter inverter;
  final VoidCallback onTap;

  const InverterCard({super.key, required this.inverter, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final inv = inverter;

    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
          child: Row(
            children: [
              // Цветной "корешок" — модуль с инициалом модели.
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      scheme.primary.withValues(alpha: 0.18),
                      scheme.primary.withValues(alpha: 0.06),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: scheme.primary.withValues(alpha: 0.18),
                  ),
                ),
                child: Icon(
                  Icons.solar_power_outlined,
                  color: scheme.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            inv.model.isEmpty
                                ? l10n.cardUnknownModel
                                : inv.model,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        _replacementBadge(scheme, l10n),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      inv.asn,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: scheme.primary,
                        fontWeight: FontWeight.w600,
                        fontFeatures: const [],
                      ),
                    ),
                    const SizedBox(height: 8),
                    _metaRow(
                      theme,
                      scheme,
                      Icons.person_outline,
                      inv.clientName.isEmpty ? '—' : inv.clientName,
                    ),
                    const SizedBox(height: 3),
                    _metaRow(
                      theme,
                      scheme,
                      Icons.place_outlined,
                      inv.locationLabel,
                    ),
                    const SizedBox(height: 9),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        if (inv.faultType != FaultType.none)
                          StatusBadge(
                            label: inv.faultType.l10n(l10n),
                            color: scheme.tertiary,
                            icon: Icons.warning_amber_rounded,
                          ),
                        StatusBadge(
                          label: l10n.cardInstalledOn(
                            Formatters.date(inv.installationDate),
                          ),
                          color: scheme.onSurfaceVariant,
                          icon: Icons.event_outlined,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: scheme.onSurfaceVariant.withValues(alpha: 0.6),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _replacementBadge(ColorScheme scheme, AppLocalizations l10n) {
    if (inverter.replaced) {
      return StatusBadge(
        label: l10n.cardStatusReplaced,
        color: scheme.error,
        icon: Icons.swap_horiz_rounded,
      );
    }
    return StatusBadge(
      label: l10n.cardStatusActive,
      color: const Color(0xFF2E9E5B),
      icon: Icons.check_circle_outline,
    );
  }

  Widget _metaRow(
    ThemeData theme,
    ColorScheme scheme,
    IconData icon,
    String text,
  ) {
    return Row(
      children: [
        Icon(icon, size: 14, color: scheme.onSurfaceVariant),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}
