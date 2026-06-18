import 'package:flutter/material.dart';

class ContactDetector {

  bool touching(
    Rect handRect,
    Rect objectRect,
  ) {

    return handRect.overlaps(
      objectRect,
    );
  }
}