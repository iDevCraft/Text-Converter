import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:text_converter/helper/string_images.dart';
import 'package:text_converter/screens/import_file.dart';
import 'package:text_converter/utils/permission_Service.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool permissionGranted = false;
  bool isCheckingPermission = true; // Loader while checking permission

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    // First time install
    bool imagesGranted = await PermissionsService.requestImagesPermission();

    if (!imagesGranted) {
      await PermissionsService.openSettingsDialog();
      setState(() {
        permissionGranted = false;
        isCheckingPermission = false;
      });
      return;
    }

    bool pdfGranted = await PermissionsService.requestPdfPermission();

    if (!pdfGranted) {
      await PermissionsService.openSettingsDialog();
      setState(() {
        permissionGranted = false;
        isCheckingPermission = false;
      });
      return;
    }

    setState(() {
      permissionGranted = true;
      isCheckingPermission = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isCheckingPermission) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (!permissionGranted) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Please allow storage and images permission to continue",
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 2.h),
                ElevatedButton(
                  onPressed: _requestPermissions,
                  child: const Text("Grant Permission"),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Image.asset(txt_component, scale: 7.5.sp),
              SizedBox(width: 2.w),
              Text(
                "EXTRACTOR",
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: [
            PopupMenuButton(
              color: lightGrey,
              itemBuilder: (context) => [
                const PopupMenuItem(value: 1, child: Text("Option 1")),
                const PopupMenuItem(value: 2, child: Text("Option 2")),
              ],
              onSelected: (value) {},
            ),
          ],
        ),
        body: Container(
          color: lightGrey,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "TO EXTRACT TEXT FROM\nPDF FILES & IMAGES",
                  style: GoogleFonts.inter(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF8d8c8c),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 2.h),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ImportFile(),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Image.asset(txt_converter, scale: 6.sp),
                      SizedBox(height: 1.h),
                      Text(
                        "EXTRACT\nTEXT",
                        style: GoogleFonts.inter(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
