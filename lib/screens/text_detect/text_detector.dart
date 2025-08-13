import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class TextDetectorHelper {
  Future<String> getRecognizedText(List<Uint8List> imageData) async {
    String finalText = "";

    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    for (var imgBytes in imageData) {
      // Step 1: Save Uint8List to temp file
      final tempDir = await getTemporaryDirectory();
      final tempFile = File(
        '${tempDir.path}/temp_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
      await tempFile.writeAsBytes(imgBytes);

      // Step 2: Create InputImage from file path
      final inputImage = InputImage.fromFilePath(tempFile.path);

      // Step 3: Process the image
      final recognizedText = await textRecognizer.processImage(inputImage);

      for (var block in recognizedText.blocks) {
        for (var line in block.lines) {
          finalText += "${line.text}\n";
        }
      }
    }

    await textRecognizer.close();
    return finalText.trim();
  }
}
