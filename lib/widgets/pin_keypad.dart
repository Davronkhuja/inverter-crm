import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Индикатор введённых цифр PIN — заполняющиеся точки.
class PinDots extends StatelessWidget {
  final int length;
  final int filled;
  final bool error;

  const PinDots({
    super.key,
    required this.length,
    required this.filled,
    this.error = false,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = error ? scheme.error : scheme.primary;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(length, (i) {
        final isFilled = i < filled;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.symmetric(horizontal: 8),
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isFilled ? color : Colors.transparent,
            border: Border.all(
              color: isFilled ? color : scheme.outlineVariant,
              width: 1.6,
            ),
          ),
        );
      }),
    );
  }
}

/// Числовая клавиатура для ввода PIN (0-9, backspace, опциональная
/// кнопка биометрии слева от 0).
class PinKeypad extends StatelessWidget {
  final ValueChanged<String> onDigit;
  final VoidCallback onBackspace;
  final VoidCallback? onBiometric;
  final IconData biometricIcon;

  const PinKeypad({
    super.key,
    required this.onDigit,
    required this.onBackspace,
    this.onBiometric,
    this.biometricIcon = Icons.fingerprint_rounded,
  });

  @override
  Widget build(BuildContext context) {
    final rows = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
    ];
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final row in rows)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: row.map((d) => _KeypadButton(
                onTap: () {
                  HapticFeedback.selectionClick();
                  onDigit(d);
                },
                child: Text(d, style: const TextStyle(fontSize: 26)),
              )).toList(),
            ),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (onBiometric != null)
                _KeypadButton(
                  onTap: onBiometric,
                  child: Icon(biometricIcon, size: 26),
                )
              else
                const _KeypadButton(child: SizedBox.shrink(), onTap: null),
              _KeypadButton(
                onTap: () {
                  HapticFeedback.selectionClick();
                  onDigit('0');
                },
                child: const Text('0', style: TextStyle(fontSize: 26)),
              ),
              _KeypadButton(
                onTap: () {
                  HapticFeedback.lightImpact();
                  onBackspace();
                },
                child: const Icon(Icons.backspace_outlined, size: 22),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _KeypadButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  const _KeypadButton({required this.child, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: Container(
            width: 72,
            height: 72,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: scheme.surfaceContainerHighest.withValues(alpha: 0.4),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}