import 'package:camera/camera.dart';

class FrameData {

  final CameraImage image;

  final DateTime timestamp;

  FrameData({
    required this.image,
    required this.timestamp,
  });
}