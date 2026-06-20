import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  debugPrint('MAIN: WidgetsFlutterBinding initialized');
  debugPrint('MAIN: calling runApp');
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
    debugPrint('MAIN: BoxInventoryApp.build() called');
    return MaterialApp(
      debugShowCheckedModeBanner:
          false,
      title: 'Box Inventory',
      home: const HomeScreen(),
    );
  }
}