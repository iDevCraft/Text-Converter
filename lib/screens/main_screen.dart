import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:text_converter/helper/string_images.dart';
import 'package:text_converter/screens/import_file.dart';
import 'package:text_converter/widgets/customDialogBox.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 10.h,
          title: Column(
            children: [
              Row(
                children: [
                  Image.asset(txt_component, scale: 7.sp),
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
              Divider(),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.more_vert, color: Colors.white),
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "TO EXTRACT TEXT FROM\nPDF FILES & IMAGES ",
                style: GoogleFonts.inter(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF8d8c8c),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 2.h),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return ImportFile();
                      },
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
    );
  }
}
