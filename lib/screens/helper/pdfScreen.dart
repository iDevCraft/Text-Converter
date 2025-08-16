import 'dart:io';
import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:text_converter/helper/string_images.dart';

class PdfScreen extends StatefulWidget {
  const PdfScreen({super.key});

  @override
  State<PdfScreen> createState() => _PdfScreenState();
}

class _PdfScreenState extends State<PdfScreen> {
  List<File> pdfFiles = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkPermissionAndLoadPdfs();
  }

  Future<void> _checkPermissionAndLoadPdfs() async {
    setState(() => isLoading = true);

    // Special permission
    bool granted = await _requestStoragePermission();

    if (!mounted) return;

    if (!granted) {
      setState(() => isLoading = false);
      return;
    }

    // Start fetching PDFs
    pdfFiles.clear();

    // Common accessible folders
    List<Directory> folders = [
      Directory("/storage/emulated/0/Download"),
      Directory("/storage/emulated/0/Documents"),
      Directory("/storage/emulated/0/"),
    ];

    for (var folder in folders) {
      await _scanDirectory(folder);
    }

    if (!mounted) return;
    setState(() => isLoading = false);
  }

  Future<bool> _requestStoragePermission() async {
    if (!Platform.isAndroid) return true;

    final androidInfo = await DeviceInfoPlugin().androidInfo;
    int sdkInt = androidInfo.version.sdkInt;

    if (sdkInt >= 30) {
      if (await Permission.manageExternalStorage.isGranted) return true;
      var status = await Permission.manageExternalStorage.request();
      return status.isGranted;
    } else {
      var status = await Permission.storage.status;
      if (!status.isGranted) status = await Permission.storage.request();
      return status.isGranted;
    }
  }

  // Future<void> _loadPdfFiles() async {
  //   pdfFiles.clear();

  //   try {
  //     final rootDir = Directory("/storage/emulated/0");
  //     await _scanDirectory(rootDir);
  //   } catch (e) {
  //     debugPrint("Error scanning files: $e");
  //   }

  //   if (!mounted) return;
  //   setState(() => isLoading = false);
  // }

  Future<void> _scanDirectory(Directory dir) async {
    try {
      if (!await dir.exists()) return;

      await for (var entity in dir.list(recursive: true, followLinks: false)) {
        if (entity is File && entity.path.toLowerCase().endsWith('.pdf')) {
          pdfFiles.add(entity);
        } else if (entity is Directory) {
          String folderName = entity.path.split('/').last.toLowerCase();
          if (folderName == "android" ||
              folderName == "obb" ||
              folderName == "data") {
            continue; // skip restricted folders
          }
        }
      }
    } catch (e) {
      debugPrint("Error accessing ${dir.path}: $e");
    }
  }

  String formatBytes(int bytes) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB"];
    int i = (bytes.bitLength - 1) ~/ 10;
    double size = bytes / (1 << (10 * i));
    return "${size.toStringAsFixed(2)} ${suffixes[i]}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2b2b2b),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : pdfFiles.isEmpty
          ? RefreshIndicator(
              color: Colors.blueAccent,
              onRefresh: _checkPermissionAndLoadPdfs,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 300),
                  Center(
                    child: Text(
                      "No PDF files found",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              color: Colors.blueAccent,
              onRefresh: _checkPermissionAndLoadPdfs,
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: pdfFiles.length,
                itemBuilder: (context, index) {
                  final file = pdfFiles[index];
                  return Card(
                    child: ListTile(
                      leading: Image.asset(pdf),
                      title: Text(
                        file.path.split('/').last,
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        formatBytes(file.lengthSync()),
                        style: const TextStyle(color: Colors.grey),
                      ),
                      onTap: () {
                        // TODO: Open PDF file
                      },
                    ),
                  );
                },
              ),
            ),
    );
  }
}
