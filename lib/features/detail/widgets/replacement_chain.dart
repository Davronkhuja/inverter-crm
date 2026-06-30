import 'package:flutter/material.dart';

import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_icons_context.dart';
import '../../../data/models/inverter.dart';
import '../../../l10n/app_localizations.dart';

/// Визуализация цепочки замен: Old ASN -> New ASN -> Next ASN.
/// Текущий инвертор подсвечен. Любой узел кликабелен для перехода.
class ReplacementChain extends StatelessWidget {
  final List<Inverter> chain;
  final String currentAsn;
  final void Function(Inverter) onTap;

  const ReplacementChain({
    super.key,
    required this.chain,
    required this.currentAsn,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final icons = context.icons;

    return Column(
      children: [
        for (var i = 0; i < chain.length; i++) ...[
          _node(theme, scheme, icons, l10n, chain[i], i),
          if (i < chain.length - 1) _connector(scheme),
        ],
      ],
    );
  }

  Widget _node(
    ThemeData theme,
    ColorScheme scheme,
    AppIconSet icons,
    AppLocalizations l10n,
    Inverter inv,
    int index,
  ) {
    final isCurrent = inv.asn == currentAsn;
    final isLast = index == chain.length - 1;
    return Material(
      color: isCurrent
          ? scheme.primary.withValues(alpha: 0.10)
          : scheme.surfaceContainerHighest.withValues(alpha: 0.35),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: isCurrent ? null : () => onTap(inv),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isCurrent
                  ? scheme.primary.withValues(alpha: 0.5)
                  : scheme.outlineVariant.withValues(alpha: 0.6),
              width: isCurrent ? 1.4 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: isLast && !inv.replaced
                      ? const Color(0xFF2E9E5B).withValues(alpha: 0.15)
                      : scheme.primary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isLast && !inv.replaced ? icons.check : icons.unit,
                  size: 17,
                  color: isLast && !inv.replaced
                      ? const Color(0xFF2E9E5B)
                      : scheme.primary,
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            inv.asn,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        if (isCurrent) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: scheme.primary,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              l10n.chainCurrent,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    Text(
                      inv.model.isEmpty ? '—' : inv.model,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (!isCurrent)
                Icon(
                  icons.arrowOutward,
                  size: 18,
                  color: scheme.onSurfaceVariant,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _connector(ColorScheme scheme) {
    return SizedBox(
      height: 22,
      child: Center(
        child: Column(
          children: [
            Container(width: 2, height: 9, color: scheme.outlineVariant),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 16,
              color: scheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
