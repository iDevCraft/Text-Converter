import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class Pdfscreen extends StatefulWidget {
  const Pdfscreen({super.key});

  @override
  State<Pdfscreen> createState() => _PdfscreenState();
}

class _PdfscreenState extends State<Pdfscreen> {
  List<File> pdfFiles = [];
  bool isLoading = true;
  Set<int> selectedIndexes = {};

  @override
  void initState() {
    super.initState();
    _checkPermissionAndLoadPdfs();
  }

  Future<void> _checkPermissionAndLoadPdfs() async {
    bool permissionGranted = await _requestPermission();

    if (!permissionGranted) {
      // Show dialog asking user to enable permission from settings
      await _showPermissionDialog();
      setState(() => isLoading = false);
      return;
    }

    await _loadPdfFiles();
  }

  Future<bool> _requestPermission() async {
    if (!Platform.isAndroid) return true;

    // Android 11+ require MANAGE_EXTERNAL_STORAGE for full access
    if (await Permission.manageExternalStorage.isGranted) {
      return true;
    }

    var status = await Permission.manageExternalStorage.request();

    if (status.isGranted) {
      return true;
    } else if (status.isPermanentlyDenied) {
      return false; // We will ask user to open settings
    }

    // fallback: try legacy storage permission for older versions
    var storageStatus = await Permission.storage.status;
    if (!storageStatus.isGranted) {
      storageStatus = await Permission.storage.request();
      return storageStatus.isGranted;
    }

    return true;
  }

  Future<void> _showPermissionDialog() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permission Required'),
        content: const Text(
          'Storage permission is required to load PDF files. Please enable it in app settings.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Future<void> _loadPdfFiles() async {
    setState(() {
      isLoading = true;
      pdfFiles.clear();
    });

    final Directory rootDir = Directory('/storage/emulated/0/');

    if (!await rootDir.exists()) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      await for (var entity in rootDir.list(
        recursive: true,
        followLinks: false,
      )) {
        if (entity is File && entity.path.toLowerCase().endsWith('.pdf')) {
          pdfFiles.add(entity);
        }
      }
    } catch (e) {
      debugPrint('Error scanning PDFs: $e');
    }

    setState(() {
      isLoading = false;
    });
  }

  String formatBytes(int bytes, int decimals) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB"];
    var i = (bytes.bitLength - 1) ~/ 10;
    double size = bytes / (1 << (10 * i));
    return "${size.toStringAsFixed(decimals)} ${suffixes[i]}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2b2b2b),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : pdfFiles.isEmpty
          ? const Center(child: Text("No PDF files found"))
          : Padding(
              padding: EdgeInsets.all(2.w),
              child: ListView.builder(
                itemCount: pdfFiles.length,
                itemBuilder: (context, index) {
                  final file = pdfFiles[index];
                  final fileName = file.path.split('/').last;
                  final fileSize = file.lengthSync();
                  final isSelected = selectedIndexes.contains(index);

                  return ListTile(
                    leading: const Icon(
                      Icons.picture_as_pdf,
                      color: Colors.red,
                    ),
                    title: Text(fileName),
                    subtitle: Text(formatBytes(fileSize, 2)),
                    selected: isSelected,
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedIndexes.remove(index);
                        } else {
                          selectedIndexes.add(index);
                        }
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '$fileName ${isSelected ? 'deselected' : 'selected'}',
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
    );
  }
}
