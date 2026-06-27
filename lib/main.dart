import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'data/repositories/inverter_repository.dart';
import 'features/dashboard/dashboard_screen.dart';
import 'state/inverter_provider.dart';

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
  final _themeMode = ValueNotifier<ThemeMode>(ThemeMode.system);

  @override
  void dispose() {
    _themeMode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => InverterProvider(InverterRepository())..load(),
      child: ValueListenableBuilder<ThemeMode>(
        valueListenable: _themeMode,
        builder: (context, mode, _) {
          return MaterialApp(
            title: 'Inverter CRM',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: mode,
            home: DashboardScreen(themeMode: _themeMode),
          );
        },
      ),
    );
  }
}
