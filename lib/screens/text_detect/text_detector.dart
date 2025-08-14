import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class TextDetectorHelper {
  Future<List<String>> getRecognizedTexts(List<Uint8List> imageData) async {
    List<String> results = [];
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    for (var imgBytes in imageData) {
      // Save temp file
      final tempDir = await getTemporaryDirectory();
      final tempFile = File(
        '${tempDir.path}/temp_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
      await tempFile.writeAsBytes(imgBytes);

      // Process image
      final inputImage = InputImage.fromFilePath(tempFile.path);
      final recognizedText = await textRecognizer.processImage(inputImage);

      String pageText = "";
      for (var block in recognizedText.blocks) {
        for (var line in block.lines) {
          pageText += "${line.text}\n";
        }
      }

      results.add(pageText.trim());
    }

    await textRecognizer.close();
    return results;
  }
}
