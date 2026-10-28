import 'package:flutter/material.dart';

import 'screens/checkout_screen.dart';
import 'screens/playground_screen.dart';

void main() {
  runApp(const MyApp());
}

/// Root of the demo app: a coffee-shop checkout that shows SizedBox in a
/// real screen, plus a playground to change its properties live.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SizedBox Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
      ),
      home: const HomeShell(),
    );
  }
}

/// Bottom navigation that switches between the two demo screens.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _selectedIndex = 0;

  static const _screens = [CheckoutScreen(), PlaygroundScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack keeps each screen's state when switching tabs.
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.shopping_bag_outlined),
            selectedIcon: Icon(Icons.shopping_bag),
            label: 'Checkout',
          ),
          NavigationDestination(
            icon: Icon(Icons.tune_outlined),
            selectedIcon: Icon(Icons.tune),
            label: 'Playground',
          ),
        ],
      ),
    );
  }
}
