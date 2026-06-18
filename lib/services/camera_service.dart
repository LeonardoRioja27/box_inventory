import 'package:camera/camera.dart';

class CameraService {

  CameraController? controller;

  Future<void> initialize() async {

    final cameras = await availableCameras();

    final camera =
        cameras.firstWhere(
      (c) =>
          c.lensDirection ==
          CameraLensDirection.back,
    );

    controller =
        CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    await controller!.initialize();
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
  
  // I added this here, Idk
    Future<void>
        stopImageStream()
        async {

        await controller!
            .stopImageStream();
        }
  
}