import 'package:flutter/material.dart';

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
            icon: const Icon(Icons.dashboard_outlined),
            selectedIcon: const Icon(Icons.dashboard_rounded),
            label: l10n.navDashboard,
          ),
          NavigationDestination(
            icon: const Icon(Icons.warehouse_outlined),
            selectedIcon: const Icon(Icons.warehouse_rounded),
            label: l10n.navWarehouse,
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline_rounded),
            selectedIcon: const Icon(Icons.person_rounded),
            label: l10n.navAccount,
          ),
        ],
      ),
    );
  }
}
