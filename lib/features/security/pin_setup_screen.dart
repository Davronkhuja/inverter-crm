import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../state/security_provider.dart';
import '../../widgets/pin_keypad.dart';

/// Экран установки/смены PIN: сначала ввод, затем подтверждение.
/// При успехе включает блокировку приложения (appLockEnabled = true).
class PinSetupScreen extends StatefulWidget {
  const PinSetupScreen({super.key});

  @override
  State<PinSetupScreen> createState() => _PinSetupScreenState();
}

class _PinSetupScreenState extends State<PinSetupScreen> {
  static const _pinLength = 4;

  String _first = '';
  String _input = '';
  bool _confirming = false;
  bool _error = false;

  Future<void> _onDigit(String d) async {
    if (_input.length >= _pinLength) return;
    setState(() {
      _input += d;
      _error = false;
    });
    if (_input.length == _pinLength) {
      if (!_confirming) {
        setState(() {
          _first = _input;
          _input = '';
          _confirming = true;
        });
      } else {
        if (_input == _first) {
          final security = context.read<SecurityProvider>();
          await security.setPin(_input);
          await security.setAppLockEnabled(true);
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.pinSavedSuccess),
            ),
          );
          Navigator.of(context).pop(true);
        } else {
          setState(() => _error = true);
          await Future.delayed(const Duration(milliseconds: 400));
          if (mounted) {
            setState(() {
              _input = '';
              _first = '';
              _confirming = false;
            });
          }
        }
      }
    }
  }

  void _onBackspace() {
    if (_input.isEmpty) return;
    setState(() => _input = _input.substring(0, _input.length - 1));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.securitySetPin)),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _confirming ? l10n.pinConfirmTitle : l10n.pinSetupTitle,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Text(
                  _error
                      ? l10n.pinMismatch
                      : (_confirming
                          ? l10n.pinConfirmSubtitle
                          : l10n.pinSetupSubtitle),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: _error ? scheme.error : scheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 28),
                PinDots(length: _pinLength, filled: _input.length, error: _error),
                const SizedBox(height: 28),
                PinKeypad(onDigit: _onDigit, onBackspace: _onBackspace),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
