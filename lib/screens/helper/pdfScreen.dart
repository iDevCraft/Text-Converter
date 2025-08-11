import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

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
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
    }

    if (status.isGranted) {
      await _loadPdfFiles();
    } else {
      setState(() => isLoading = false); // No dialog, just stop loading
    }
  }

  Future<void> _loadPdfFiles() async {
    setState(() {
      isLoading = true;
      pdfFiles.clear();
    });

    final Directory rootDir = Directory('/storage/emulated/0/');

    try {
      await for (var entity in rootDir.list(recursive: true)) {
        if (entity is File && entity.path.toLowerCase().endsWith('.pdf')) {
          pdfFiles.add(entity);
        }
      }
    } catch (e) {
      debugPrint("Error: $e");
    }

    setState(() {
      isLoading = false;
    });
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
          : pdfFiles.isEmpty
          ? const Center(
              child: Text(
                "No PDF files found or permission denied",
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
                      // PDF open karne ka code yaha add karna hai
                    },
                  );
                },
              ),
            ),
    );
  }
}
