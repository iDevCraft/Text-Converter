import 'dart:io';
import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:text_converter/helper/string_images.dart';
import 'package:text_converter/utils/permission_Service.dart';

class PdfScreen extends StatefulWidget {
  const PdfScreen({super.key});

  @override
  State<PdfScreen> createState() => _PdfScreenState();
}

class _PdfScreenState extends State<PdfScreen>
    with AutomaticKeepAliveClientMixin {
  List<File> pdfFiles = [];
  bool isLoading = true;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _checkPermissionAndLoadPdfs();
  }

  Future<void> _checkPermissionAndLoadPdfs() async {
    setState(() => isLoading = true);

    bool granted = await PermissionsService.requestImagesPermission();

    if (!mounted) return;

    if (!granted) {
      setState(() => isLoading = false);
      return;
    }

    pdfFiles.clear();

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
            continue;
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
    super.build(context);

    return Scaffold(
      backgroundColor: lightgrey,
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
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                      ),
                      subtitle: Text(
                        formatBytes(file.lengthSync()),
                        style: GoogleFonts.inter(
                          color: Colors.grey,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onTap: () {
                        // TODO: Open PDF
                      },
                    ),
                  );
                },
              ),
            ),
    );
  }
}
