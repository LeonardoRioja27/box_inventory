import 'package:flutter/material.dart';

class TrackedObject {

  int id;

  Rect bounds;

  String label;

  DateTime lastSeen;

  bool touchingHand;
  
  List<String> ocrTexts;

  String mergedText;
  
  
  TrackedObject({
    required this.id,
    required this.bounds,
    required this.label,
    required this.lastSeen,
    required this.touchingHand,
    required this.ocrTexts,
    required this.mergedText,
  });
}