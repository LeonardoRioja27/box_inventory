import 'package:flutter/material.dart';

class ObjectOverlay extends StatelessWidget {

  final Rect rect;

  final String label;

  final int id;
  
  final bool touchingHand;
  
  final String mergedText;

  const ObjectOverlay({
    super.key,
    required this.rect,
    required this.label,
    required this.id,
    required this.touchingHand,
    required this.mergedText,
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
            color: Colors.blue,
            width: 3,
          ),
        ),
        child: Align(
          alignment: Alignment.topLeft,
          child: Container(
            color: Colors.blue,
            padding:
                const EdgeInsets.all(4),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    Text(
                      touchingHand
                          ? '$label #$id TOUCHING'
                          : '$label #$id FREE',
                      style:
                          const TextStyle(
                        color: Colors.white,
                      ),
                    ),

                    Text(
                      mergedText,
                      style:
                          const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
            
          ),
        ),
      ),
    );
  }
}