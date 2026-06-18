import 'package:flutter/material.dart';

class BoxOverlay extends StatelessWidget {

  final Rect rect;

  final Function(
    double dx,
    double dy,
  ) onMove;

  const BoxOverlay({
    super.key,
    required this.rect,
    required this.onMove,
  });

  @override
  Widget build(BuildContext context) {

    return Positioned(
      left: rect.left,
      top: rect.top,
      child: GestureDetector(
        onPanUpdate: (details) {

          onMove(
            details.delta.dx,
            details.delta.dy,
          );
        },
        child: Container(
          width: rect.width,
          height: rect.height,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.green,
              width: 3,
            ),
            color:
                Colors.green.withOpacity(
              0.15,
            ),
          ),
        ),
      ),
    );
  }
}