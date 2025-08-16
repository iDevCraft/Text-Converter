import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:device_info_plus/device_info_plus.dart';

class PdfScreen extends StatefulWidget {
  const PdfScreen({super.key});

  @override
  State<PdfScreen> createState() => _PdfScreenState();
}

class _PdfScreenState extends State<PdfScreen> {
  List<File> pdfFiles = [];
  bool isLoading = true;
  bool permissionDenied = false;

  @override
  void initState() {
    super.initState();
    _checkPermissionAndLoadPdfs();
  }

  Future<void> _checkPermissionAndLoadPdfs() async {
    bool granted = await _requestStoragePermission();

    if (!mounted) return;

    if (granted) {
      await _loadPdfFiles();
    } else {
      setState(() {
        permissionDenied = true;
        isLoading = false;
      });
    }
  }

  Future<bool> _requestStoragePermission() async {
    if (!Platform.isAndroid) return true;

    final androidInfo = await DeviceInfoPlugin().androidInfo;
    int sdkInt = androidInfo.version.sdkInt;

    if (sdkInt >= 30) {
      // Android 11+
      if (await Permission.manageExternalStorage.isGranted) return true;

      var status = await Permission.manageExternalStorage.request();
      if (status.isGranted) return true;

      // Force user to open settings
      await openAppSettings();
      return false;
    } else {
      // Android 10 and below
      var status = await Permission.storage.request();
      return status.isGranted;
    }
  }

  Future<void> _loadPdfFiles() async {
    pdfFiles.clear();
    try {
      // Scan root storage
      final rootDir = Directory("/storage/emulated/0");
      await _getFiles(rootDir.path);
    } catch (e) {
      debugPrint("Error scanning files: $e");
    }

    if (!mounted) return;
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _getFiles(String directoryPath) async {
    try {
      final dir = Directory(directoryPath);
      if (!await dir.exists()) return;

      await for (var entity in dir.list(recursive: true, followLinks: false)) {
        if (entity is File && entity.path.toLowerCase().endsWith('.pdf')) {
          pdfFiles.add(entity);
        } else if (entity is Directory) {
          // Skip restricted folders
          String folderName = entity.path.split('/').last.toLowerCase();
          if (folderName == "android" ||
              folderName == "obb" ||
              folderName == "data") {
            continue;
          }
        }
      }
    } catch (e) {
      debugPrint("Error accessing $directoryPath: $e");
    }
  }

  String formatBytes(int bytes) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB"];
    var i = (bytes.bitLength - 1) ~/ 10;
    double size = bytes / (1 << (10 * i));
    return "${size.toStringAsFixed(2)} ${suffixes[i]}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2b2b2b),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : permissionDenied
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "All Files Access is required to find PDF files",
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _checkPermissionAndLoadPdfs,
                    child: const Text("Open Settings"),
                  ),
                ],
              ),
            )
          : pdfFiles.isEmpty
          ? const Center(
              child: Text(
                "No PDF files found",
                style: TextStyle(color: Colors.white),
              ),
            )
          : Padding(
              padding: EdgeInsets.all(2.w),
              child: ListView.builder(
                itemCount: pdfFiles.length,
                itemBuilder: (context, index) {
                  final file = pdfFiles[index];
                  return ListTile(
                    leading: const Icon(
                      Icons.picture_as_pdf,
                      color: Colors.red,
                    ),
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
                  );
                },
              ),
            ),
    );
  }
}
