import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';

class CameraService {

  CameraController? controller;

  Future<void> initialize() async {
    debugPrint('CameraService.initialize(): calling availableCameras()');
    final cameras = await availableCameras();
    debugPrint('CameraService.initialize(): found ${cameras.length} cameras');

    final camera =
        cameras.firstWhere(
      (c) =>
          c.lensDirection ==
          CameraLensDirection.back,
      orElse: () {
        debugPrint('CameraService.initialize(): no back camera, using first');
        return cameras.first;
      },
    );

    debugPrint('CameraService.initialize(): creating CameraController');
    controller =
        CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    debugPrint('CameraService.initialize(): calling controller.initialize()');
    await controller!.initialize();
    debugPrint('CameraService.initialize(): controller initialized successfully');
  }


  Future<XFile?> capture() async {

      if (controller == null) {
        return null;
      }

      if (!controller!.value.isInitialized) {
        return null;
      }

      return await controller!
          .takePicture();
    }

  Future<void> dispose() async {
    await controller?.dispose();
  }
  
  // I added this here, Idk
  Future<void>
    startImageStream(
    Function(CameraImage)
      callback,
      ) async {

      await controller!
      .startImageStream(
          callback);
    }
  
  Future<void> stopImageStream() async {
    if (controller == null) return;
    if (!controller!.value.isStreamingImages) return;
    await controller!.stopImageStream();
  }
  
}