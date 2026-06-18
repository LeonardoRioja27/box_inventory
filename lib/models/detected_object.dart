import 'package:flutter/material.dart';

class DetectedObject {

  final int id;

  final Rect bounds;

  final String label;

  DetectedObject({
    required this.id,
    required this.bounds,
    required this.label,
  });
}