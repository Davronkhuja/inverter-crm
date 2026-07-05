import 'package:flutter/material.dart';

import '../../../core/constants/enums.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_icons_context.dart';
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
    final icons = context.icons;
    final isDark = theme.brightness == Brightness.dark;
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
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      scheme.primary.withValues(alpha: isDark ? 0.32 : 0.20),
                      scheme.tertiary.withValues(alpha: isDark ? 0.18 : 0.08),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(13),
                  border: Border.all(
                    color: scheme.primary.withValues(alpha: 0.18),
                  ),
                ),
                child: Icon(icons.unit, color: scheme.primary, size: 22),
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
                        _replacementBadge(scheme, icons, l10n),
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
                      ),
                    ),
                    const SizedBox(height: 8),
                    _metaRow(
                      theme,
                      scheme,
                      icons.client,
                      inv.clientName.isEmpty ? '—' : inv.clientName,
                    ),
                    const SizedBox(height: 3),
                    _metaRow(
                      theme,
                      scheme,
                      icons.location,
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
                            icon: icons.fault,
                          ),
                        StatusBadge(
                          label: l10n.cardInstalledOn(
                            Formatters.date(inv.installationDate),
                          ),
                          color: scheme.onSurfaceVariant,
                          icon: icons.calendar,
                        ),
                        ..._warrantyBadge(inv, l10n, scheme, icons),
                      ],
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
    );
  }

  Widget _replacementBadge(
    ColorScheme scheme,
    AppIconSet icons,
    AppLocalizations l10n,
  ) {
    if (inverter.replaced) {
      return StatusBadge(
        label: l10n.cardStatusReplaced,
        color: scheme.error,
        icon: icons.statusReplaced,
      );
    }
    return StatusBadge(
      label: l10n.cardStatusActive,
      color: const Color(0xFF2E9E5B),
      icon: icons.statusActive,
    );
  }

  // Shows a warranty badge only when expiry is within 180 days or already past.
  List<Widget> _warrantyBadge(
    Inverter inv,
    AppLocalizations l10n,
    ColorScheme scheme,
    AppIconSet icons,
  ) {
    if (inv.saleDate == null || inv.replaced) return const [];
    final expiry = DateTime(
      inv.saleDate!.year + 5,
      inv.saleDate!.month,
      inv.saleDate!.day,
    );
    final daysLeft = expiry.difference(DateTime.now()).inDays;
    if (daysLeft > 180) return const [];
    final color = daysLeft <= 0
        ? scheme.error
        : daysLeft <= 30
            ? scheme.error.withValues(alpha: 0.85)
            : const Color(0xFFE67E22);
    final label = daysLeft <= 0
        ? l10n.warrantyExpired
        : l10n.warrantyDaysLeft(daysLeft);
    return [StatusBadge(label: label, color: color, icon: icons.calendar)];
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
