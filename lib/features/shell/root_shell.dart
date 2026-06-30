import 'package:flutter/material.dart';

import '../../core/theme/app_icons_context.dart';
import '../../l10n/app_localizations.dart';
import '../account/account_screen.dart';
import '../dashboard/dashboard_screen.dart';
import '../warehouse/warehouse_screen.dart';

/// Корневой каркас приложения: нижняя навигация между Dashboard,
/// Warehouse и Account. Каждая вкладка хранит собственное состояние
/// благодаря IndexedStack (не пересоздаётся при переключении).
class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final icons = context.icons;

    final screens = const [
      DashboardScreen(),
      WarehouseScreen(),
      AccountScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: _index, children: screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: [
          NavigationDestination(
            icon: Icon(icons.navDashboard),
            selectedIcon: Icon(icons.navDashboardSelected),
            label: l10n.navDashboard,
          ),
          NavigationDestination(
            icon: Icon(icons.navWarehouse),
            selectedIcon: Icon(icons.navWarehouseSelected),
            label: l10n.navWarehouse,
          ),
          NavigationDestination(
            icon: Icon(icons.navAccount),
            selectedIcon: Icon(icons.navAccountSelected),
            label: l10n.navAccount,
          ),
        ],
      ),
    );
  }
}
