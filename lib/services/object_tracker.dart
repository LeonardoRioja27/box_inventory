import 'package:flutter/material.dart';

import '../models/detected_object.dart';
import '../models/tracked_object.dart';

class ObjectTracker {

    Offset center(Rect rect) {
        return Offset(
        rect.left +
            rect.width / 2,
        rect.top +
            rect.height / 2,
        );
    }
    
    double distance(
      Offset a,
      Offset b,
    ) {
        return (a - b).distance;
    }

  final List<TrackedObject>
      trackedObjects = [];

  int nextId = 1;

  List<TrackedObject> update(
  List<DetectedObject> detections,
  ) {

      for (final detection
          in detections) {

        TrackedObject? bestMatch;

        double bestDistance =
            double.infinity;

        for (final tracked
            in trackedObjects) {

          final d = distance(
            center(
              detection.bounds,
            ),
            center(
              tracked.bounds,
            ),
          );

          if (d <
              bestDistance) {

            bestDistance = d;

            bestMatch = tracked;
          }
        }

        if (bestMatch != null &&
            bestDistance < 100) {

          bestMatch.bounds =
              detection.bounds;

          bestMatch.lastSeen =
              DateTime.now();
        }

        else {

          trackedObjects.add(
            TrackedObject(
              id: nextId++,
              bounds:
                  detection.bounds,
              label:
                  detection.label,
              lastSeen:
                  DateTime.now(),
                touchingHand: false,
                ocrTexts: [],
                mergedText: '',
            ),
          );
        }
      }

      return trackedObjects;
    }
}