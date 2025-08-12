import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:external_path/external_path.dart';

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
    bool granted = false;
    setState(() {
      isLoading = true;
      permissionDenied = false;
    });

    if (Platform.isAndroid) {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;

      if (androidInfo.version.sdkInt < 30) {
        // Android 10 and below
        granted = await Permission.storage.isGranted;
        if (!granted) {
          var status = await Permission.storage.request();
          granted = status.isGranted;
        }
      } else {
        // Android 11 and above
        granted = await Permission.manageExternalStorage.isGranted;
        if (!granted) {
          var status = await Permission.manageExternalStorage.request();
          granted = status.isGranted;
        }
      }
    } else {
      granted = true; // Non-Android platforms
    }

    if (granted) {
      await _loadPdfFiles();
    } else {
      setState(() {
        permissionDenied = true;
        isLoading = false;
      });
    }
  }

  Future<void> _loadPdfFiles() async {
    pdfFiles.clear();
    try {
      List<String> storagePaths =
          await ExternalPath.getExternalStorageDirectories() ?? [];

      // Scan each available storage directory
      for (String path in storagePaths) {
        await _getFiles(path);
      }
    } catch (e) {
      debugPrint("Error scanning files: $e");
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _getFiles(String directoryPath) async {
    try {
      final rootDir = Directory(directoryPath);

      await for (var entity in rootDir.list(recursive: false)) {
        if (entity is File) {
          if (entity.path.toLowerCase().endsWith('.pdf')) {
            pdfFiles.add(entity);
          }
        } else if (entity is Directory) {
          // Skip restricted folders
          String folderName = entity.path.split('/').last.toLowerCase();
          if (folderName != 'android' &&
              folderName != 'data' &&
              folderName != 'obb') {
            await _getFiles(entity.path);
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
          ? const Center(child: CircularProgressIndicator())
          : permissionDenied
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Storage permission is required to find PDF files",
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _checkPermissionAndLoadPdfs,
                    child: const Text("Grant Permission"),
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
                      // PDF open karne ka code yaha add karo
                    },
                  );
                },
              ),
            ),
    );
  }
}
