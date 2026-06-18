import 'package:flutter/material.dart';

class HandOverlay extends StatelessWidget {

  final Rect rect;

  const HandOverlay({
    super.key,
    required this.rect,
  });

  @override
  Widget build(BuildContext context) {

    return Positioned(
      left: rect.left,
      top: rect.top,
      child: Container(
        width: rect.width,
        height: rect.height,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.red,
            width: 3,
          ),
        ),
      ),
    );
  }
}