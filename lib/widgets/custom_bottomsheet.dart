import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:text_converter/helper/string_images.dart';
import 'package:text_converter/screens/fetch_file.dart';
import 'package:text_converter/screens/helper/imagesScreen.dart';
import 'package:text_converter/screens/helper/pdfScreen.dart';

Future<void> customBottomSheet({required BuildContext context}) {
  List<Uint8List> selectedImages = [];

  return showModalBottomSheet(
    useSafeArea: true,
    isScrollControlled: true,
    context: context,
    builder: (context) {
      return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Image.asset(back),
            ),
            actions: [
              Container(
                margin: EdgeInsets.only(right: 2.w),
                child: TextButton(
                  onPressed: () {
                    if (selectedImages.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Please Select Image"),
                          duration: Duration(milliseconds: 2000),
                        ),
                      );
                    } else {
                      Navigator.pop(context); // close bottom sheet
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              FetchFile(selectedFiles: selectedImages),
                        ),
                      );
                    }
                  },
                  child: Text(
                    "Done",
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
            title: Text(
              "SELECT FILE",
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
              ),
            ),
            bottom: TabBar(
              labelColor: Colors.white,
              dividerHeight: 0.1,
              labelStyle: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w800,
              ),
              indicatorColor: Colors.white,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorWeight: 2,
              tabs: const [
                Tab(text: "Images"),
                Tab(text: "PDF Files"),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Imagesscreen(
                onImagesSelected: (files) {
                  selectedImages = files;
                },
              ),
              PdfScreen(),
            ],
          ),
        ),
      );
    },
  );
}
