import 'package:camera/camera.dart';
import 'dart:io';
import 'dart:async';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import 'package:flutter/material.dart';

import '../services/camera_service.dart';
import '../widgets/box_overlay.dart';
import '../services/hand_detector.dart';
import '../models/hand_detection.dart';
import '../widgets/hand_overlay.dart';
import '../models/detected_object.dart';
import '../services/object_detector.dart';
import '../widgets/object_overlay.dart';
import '../services/object_tracker.dart';
import '../models/tracked_object.dart';
import '../services/contact_detector.dart';
import '../services/ocr_service.dart';
import '../services/ocr_accumulator.dart';

//in phase 4, there might be a mistake 
class LiveCameraScreen
    extends StatefulWidget {

  final int boxId;

  const LiveCameraScreen({
    super.key,
    required this.boxId,
  });

  @override
  State<LiveCameraScreen>
      createState() =>
      _LiveCameraScreenState();
}

class _LiveCameraScreenState
    extends State<LiveCameraScreen> {


  final CameraService
      _cameraService =
      CameraService();

    final HandDetector
      _handDetector =
      HandDetector();

      final ObjectDetector
    _objectDetector =
    ObjectDetector();
    
    final ObjectTracker
    _objectTracker =
    ObjectTracker();

    final ContactDetector
    _contactDetector =
    ContactDetector();
    
    final OCRService
        _ocrService =
        OCRService();

    final OCRAccumulator
        _ocrAccumulator =
        OCRAccumulator();
    
  bool initialized = false;

  int frameCounter = 0;
  int objectCounter = 0;

  bool ocrBusy = false;
  
  bool captureBusy = false;

    DateTime lastOCR =
        DateTime.fromMillisecondsSinceEpoch(
      0,
    );

  Rect boxRect = const Rect.fromLTWH(
      100,
      150,
      200,
      200,
    );

    List<HandDetection> hands = [];
    
    List<DetectedObject>
    objects = [];
    
    List<TrackedObject>
    trackedObjects = [];
    
    
    void updateContacts() {

      for (final object
          in trackedObjects) {

        object.touchingHand =
            false;

        for (final hand
            in hands) {

          if (_contactDetector
              .touching(
            hand.bounds,
            object.bounds,
          )) {

            object.touchingHand =
                true;

            break;
          }
        }
      }
    }
    
    
    Future<void> updateOCR(
      CameraImage image,
    ) async {

      if (!shouldRunOCR()) {
        return;
      }

      ocrBusy = true;

      try {

        final inputImage =
            await createInputImage(
          image,
        );

        if (inputImage == null) {
          return;
        }

        final text =
            await _ocrService
                .recognize(
          inputImage,
        );

        print(
          'OCR TEXT: $text',
        );
        
        for (final object
            in trackedObjects) {

          if (false) {
            continue;
          }

          if (text.trim().isEmpty) {
            continue;
          }

          object.ocrTexts.add(
            text,
          );

          object.mergedText =
              _ocrAccumulator.merge(
            object.ocrTexts,
          );
        }

        lastOCR = DateTime.now();

      } finally {

        ocrBusy = false;
      }
    }
    
    
    bool shouldRunOCR() {

      if (ocrBusy) {
        return false;
      }

      final now =
          DateTime.now();

      if (now
              .difference(
                lastOCR,
              )
              .inMilliseconds <
          500) {

        return false;
      }

      return true;
    }
    
    Future<InputImage?>
        createInputImage(
          CameraImage image,
        ) async {
            
            return null;
          }

  @override
  void initState() {
    super.initState();

    _initialize();
  }

  Future<void> _initialize() async {

    await _cameraService.initialize();
  
    await _cameraService
          .startImageStream(
        (image) {

          frameCounter++;

          if (frameCounter == 1) {

              debugPrint(
                'FORMAT=${image.format.group}',
              );

              debugPrint(
                'PLANES=${image.planes.length}',
              );

              debugPrint(
                'WIDTH=${image.width}',
              );

              debugPrint(
                'HEIGHT=${image.height}',
              );

              for (int i = 0;
                  i < image.planes.length;
                  i++) {

                debugPrint(
                  'PLANE $i '
                  'BYTES_PER_ROW='
                  '${image.planes[i].bytesPerRow}',
                );
              }
            }
        
          
          if (frameCounter == 1) {

              print(
                'FORMAT: '
                '${image.format.group}',
              );

              print(
                'PLANES: '
                '${image.planes.length}',
              );

              print(
                'WIDTH: '
                '${image.width}',
              );

              print(
                'HEIGHT: '
                '${image.height}',
              );
            }
            
          if (frameCounter %
                  30 ==
              0) {

              setState(() {

                hands = [

                  HandDetection(
                    bounds:
                        const Rect.fromLTWH(
                            280,
                          330,
                          160,
                          160,
                    ),
                  ),

                ];

                objects = [

                  DetectedObject(
                    id: 1,
                    bounds:
                        const Rect.fromLTWH(
                      300,
                      350,
                      140,
                      200,
                    ),
                    label: 'Object',
                  ),

                ];
                
                trackedObjects =
                    _objectTracker.update(
                        objects,
                    );
                
                updateContacts();
                
                //unawaited(
                //  updateOCR(image),
                //);
                
              });

            print(
              'Frame $frameCounter',
            );
          }
        },
        );

    if (!mounted) {
      return;
    }

    setState(() {
      initialized = true;
    });
  }

  @override
 void dispose() {

   try {
     _cameraService.stopImageStream();
   } catch (_) {}

   _ocrService.dispose();

   _cameraService.dispose();

   super.dispose();
 }

  @override
  Widget build(
      BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Box #${widget.boxId}',
        ),
      ),
      body: !initialized
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )
          : Stack(
              children: [

                CameraPreview(
                  _cameraService
                      .controller!,
                ),
                
                BoxOverlay(
                  rect: boxRect,
                  onMove: (dx, dy) {

                    setState(() {

                      boxRect = boxRect.shift(
                        Offset(dx, dy),
                      );

                    });
                  },
                ),
                
                ...hands.map(
                  (hand) => HandOverlay(
                    rect: hand.bounds,
                  ),
                ),
                    
                ...trackedObjects.map(
                  (object) =>
                      ObjectOverlay(
                    rect: object.bounds,
                    label: object.label,
                    id: object.id,
                    touchingHand: object.touchingHand,
                    mergedText: object.mergedText,
                  ),
                ),
                
                Positioned(
                  right: 20,
                  top: 20,
                  child: Container(
                    width: 220,
                    color: Colors.black54,
                    padding:
                        const EdgeInsets.all(8),
                    child: Text(
                      trackedObjects
                          .isEmpty
                          ? ''
                          : trackedObjects
                              .first
                              .mergedText,
                      style:
                          const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                
                
                
                Positioned(
                  top: 230,
                  left: 20,
                  child: Container(
                    color: Colors.black54,
                    padding:
                        const EdgeInsets.all(8),
                    child: Text(
                      ocrBusy
                          ? 'OCR RUNNING'
                          : 'OCR IDLE',
                      style:
                          const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                
                
                Positioned(
                  top: 180,
                  left: 20,
                  child: Container(
                    color: Colors.black54,
                    padding:
                        const EdgeInsets.all(8),
                    child: Text(
                      'OCR Objects: '
                      '${trackedObjects.where(
                        (o) =>
                            o.mergedText
                                .isNotEmpty,
                      ).length}',
                      style:
                          const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                
                Positioned(
                  top: 130,
                  left: 20,
                  child: Container(
                    color: Colors.black54,
                    padding:
                        const EdgeInsets.all(8),
                    child: Text(
                      'Touching: '
                      '${trackedObjects.where(
                        (o) =>
                            o.touchingHand,
                      ).length}',
                      style:
                          const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                
                
                
                Positioned(
                  top: 80,
                  left: 20,
                  child: Container(
                    color: Colors.black54,
                    padding:
                        const EdgeInsets.all(8),
                    child: Text(
                      'Tracked: '
                      '${trackedObjects.length}',
                      style:
                          const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: Container(
                    color: Colors.black54,
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      'BOX: '
                      '${boxRect.left.toInt()}, '
                      '${boxRect.top.toInt()}',
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 20,
                  left: 20,
                  child: Container(
                    padding:
                        const EdgeInsets
                            .all(12),
                    color: Colors.black54,
                    child: Text(
                      'BOX ${widget.boxId}',
                      style:
                          const TextStyle(
                        color:
                            Colors.white,
                        fontSize:
                            20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}