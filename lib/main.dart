import 'dart:async';
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError(
    (details) {

      FlutterError.dumpErrorToConsole(
        details,
      );
    },
  );

  runZonedGuarded(
    () {

      runApp(
        const BoxInventoryApp(),
      );

    },
    (error, stack) {

      debugPrint(
        'UNCAUGHT ERROR: $error',
      );

      debugPrint(
        stack.toString(),
      );
    },
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
