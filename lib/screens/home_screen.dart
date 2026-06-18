import 'package:flutter/material.dart';

import '../database/database.dart';
import 'boxes_screen.dart';
import 'live_camera_screen.dart';

class HomeScreen
    extends StatelessWidget {

  const HomeScreen({
    super.key,
  });

  Future<void>
      _createBox(
          BuildContext context)
      async {

    final boxId =
        await DatabaseService.instance
            .createBox();

    if (!context.mounted) {
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) =>
            LiveCameraScreen(
          boxId: boxId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Box Inventory',
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [

            ElevatedButton(
              onPressed: () =>
                  _createBox(
                      context),
              child: const Text(
                'Start New Box',
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            ElevatedButton(
              onPressed: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) =>
                        const BoxesScreen(),
                  ),
                );
              },
              child: const Text(
                'Past Boxes',
              ),
            ),
          ],
        ),
      ),
    );
  }
}