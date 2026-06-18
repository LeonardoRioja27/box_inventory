import 'package:flutter/material.dart';

import '../database/database.dart';
import 'live_camera_screen.dart';

class BoxesScreen extends StatefulWidget {
  const BoxesScreen({
    super.key,
  });

  @override
  State<BoxesScreen> createState() =>
      _BoxesScreenState();
}

class _BoxesScreenState
    extends State<BoxesScreen> {

  late Future<List<Map<String,dynamic>>>
      _boxesFuture;

  @override
  void initState() {
    super.initState();

    _boxesFuture =
        DatabaseService.instance
            .getBoxes();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Past Boxes',
        ),
      ),
      body: FutureBuilder<
          List<Map<String,dynamic>>>(
        future: _boxesFuture,
        builder:
            (context,snapshot) {

          if (!snapshot.hasData) {
            return const Center(
              child:
                  CircularProgressIndicator(),
            );
          }

          final boxes =
              snapshot.data!;

          if (boxes.isEmpty) {
            return const Center(
              child: Text(
                'No boxes found',
              ),
            );
          }

          return ListView.builder(
            itemCount:
                boxes.length,
            itemBuilder:
                (context,index) {

              final box =
                  boxes[index];

              return ListTile(
                leading:
                    const Icon(
                  Icons.inventory,
                ),
                title: Text(
                  'Box #${box['id']}',
                ),
                subtitle: Text(
                  box['started_at'],
                ),
                onTap: () {

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) =>
                          LiveCameraScreen(
                        boxId:
                            box['id'],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}