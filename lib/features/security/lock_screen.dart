import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../state/security_provider.dart';
import '../../widgets/pin_keypad.dart';

/// Полноэкранный замок приложения. Показывается над всем остальным UI,
/// когда [SecurityProvider.locked] == true. Не использует Navigator —
/// просто перекрывает дерево виджетов, чтобы не мешать стеку навигации.
class LockScreen extends StatefulWidget {
  const LockScreen({super.key});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  static const _pinLength = 4;
  String _input = '';
  bool _error = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeAutoBiometric());
  }

  Future<void> _maybeAutoBiometric() async {
    final security = context.read<SecurityProvider>();
    if (security.biometricEnabled && security.biometricAvailable) {
      await _tryBiometric();
    }
  }

  Future<void> _tryBiometric() async {
    final security = context.read<SecurityProvider>();
    final ok = await security.authenticateWithBiometrics();
    if (ok) security.unlock();
  }

  Future<void> _onDigit(String d) async {
    if (_input.length >= _pinLength) return;
    setState(() {
      _input += d;
      _error = false;
    });
    if (_input.length == _pinLength) {
      final security = context.read<SecurityProvider>();
      final ok = await security.verifyPin(_input);
      if (ok) {
        security.unlock();
      } else {
        setState(() => _error = true);
        await Future.delayed(const Duration(milliseconds: 400));
        if (mounted) setState(() => _input = '');
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
    final security = context.watch<SecurityProvider>();

    return Material(
      color: theme.scaffoldBackgroundColor,
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: scheme.primary,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(
                    Icons.lock_outline_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  l10n.lockTitle,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _error ? l10n.lockWrongPin : l10n.lockSubtitle,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: _error ? scheme.error : scheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 28),
                PinDots(length: _pinLength, filled: _input.length, error: _error),
                const SizedBox(height: 28),
                PinKeypad(
                  onDigit: _onDigit,
                  onBackspace: _onBackspace,
                  onBiometric: security.biometricEnabled && security.biometricAvailable
                      ? _tryBiometric
                      : null,
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.lockForgotHint,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
