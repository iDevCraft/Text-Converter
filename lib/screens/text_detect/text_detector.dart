import 'dart:typed_data';
import 'dart:ui';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class TextDetectorHelper {
  Future<String> getRecognizedText(Uint8List imageData) async {
    // Metadata banana zaroori hai
    final metadata = InputImageMetadata(
      size: Size(
        100,
        100,
      ), // Ye placeholder hai, actual size detect kar sakte ho
      rotation: InputImageRotation.rotation0deg,
      format: InputImageFormat.bgra8888,
      bytesPerRow: 100 * 4, // width * 4 bytes per pixel
    );

    final inputImage = InputImage.fromBytes(
      bytes: imageData,
      metadata: metadata,
    );

    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final recognizedText = await textRecognizer.processImage(inputImage);

    String finalText = "";
    for (var block in recognizedText.blocks) {
      for (var line in block.lines) {
        finalText += "${line.text}\n";
      }
    }

    await textRecognizer.close();
    return finalText.trim();
  }
}
