import 'package:flutter/material.dart';

/// Небольшой цветной бейдж со статусом (Replaced / Active / тип неисправности).
/// Используется в списке и на детальной странице — единый визуальный язык.
class StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  final IconData? icon;
  final bool subtle;

  const StatusBadge({
    super.key,
    required this.label,
    required this.color,
    this.icon,
    this.subtle = true,
  });

  @override
  Widget build(BuildContext context) {
    final bg = subtle ? color.withValues(alpha: 0.12) : color;
    final fg = subtle ? color : _onColor(color);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: icon == null ? 10 : 8,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
        border: subtle
            ? Border.all(color: color.withValues(alpha: 0.25))
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: fg),
            const SizedBox(width: 4),
          ],
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: fg,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Color _onColor(Color c) {
    return c.computeLuminance() > 0.5 ? Colors.black : Colors.white;
  }
}
