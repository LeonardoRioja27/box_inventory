import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(
    const BoxInventoryApp(),
  );
}

class BoxInventoryApp
    extends StatelessWidget {

  const BoxInventoryApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner:
          false,
      title: 'Box Inventory',
      home: const HomeScreen(),
    );
  }
}