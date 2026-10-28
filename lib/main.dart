import 'package:flutter/material.dart';

import 'screens/checkout_screen.dart';

void main() {
  runApp(const MyApp());
}

/// Root of the demo app: a coffee-shop checkout that shows SizedBox in a
/// real screen.
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
      home: const CheckoutScreen(),
    );
  }
}
