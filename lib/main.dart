import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'data/repositories/inverter_repository.dart';
import 'features/security/lock_screen.dart';
import 'features/shell/root_shell.dart';
import 'l10n/app_localizations.dart';
import 'state/inverter_provider.dart';
import 'state/security_provider.dart';
import 'state/settings_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const InverterCrmApp());
}

class InverterCrmApp extends StatefulWidget {
  const InverterCrmApp({super.key});

  @override
  State<InverterCrmApp> createState() => _InverterCrmAppState();
}

class _InverterCrmAppState extends State<InverterCrmApp> {
  late final SettingsProvider _settings;
  late final SecurityProvider _security;

  @override
  void initState() {
    super.initState();
    _settings = SettingsProvider()..load();
    _security = SecurityProvider()..load();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => InverterProvider(InverterRepository())..load(),
        ),
        ChangeNotifierProvider.value(value: _settings),
        ChangeNotifierProvider.value(value: _security),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settings, _) {
          return MaterialApp(
            title: 'Inverter CRM',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: settings.themeMode,
            locale: settings.locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            home: _AppLifecycleBoundary(
              security: _security,
              child: const RootShell(),
            ),
          );
        },
      ),
    );
  }
}

/// Следит за жизненным циклом приложения, чтобы повторно блокировать
/// экран при возврате из фона, и показывает [LockScreen] поверх всего
/// дерева, когда приложение заблокировано.
class _AppLifecycleBoundary extends StatefulWidget {
  final SecurityProvider security;
  final Widget child;
  const _AppLifecycleBoundary({required this.security, required this.child});

  @override
  State<_AppLifecycleBoundary> createState() => _AppLifecycleBoundaryState();
}

class _AppLifecycleBoundaryState extends State<_AppLifecycleBoundary>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      widget.security.relock();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.security,
      builder: (context, _) {
        return Stack(
          children: [
            widget.child,
            if (widget.security.locked) const LockScreen(),
          ],
        );
      },
    );
  }
}
