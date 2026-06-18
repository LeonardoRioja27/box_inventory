import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class OCRService {

  final TextRecognizer
      recognizer =
      TextRecognizer();

  Future<String> recognize(
    InputImage image,
  ) async {

    final result =
        await recognizer
            .processImage(
      image,
    );

    return result.text;
  }

  Future<void> dispose()
      async {

    await recognizer.close();
  }
}