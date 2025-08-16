import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:text_converter/helper/string_images.dart';
import 'package:text_converter/screens/fetch_file.dart';
import 'package:text_converter/screens/helper/imagesScreen.dart';
import 'package:text_converter/screens/helper/pdfScreen.dart';

Future<void> customBottomSheet({
  required BuildContext context,
  required List<Uint8List> alreadySelectedImages, // 👈 ab yahi rakhenge
  required Function(List<Uint8List>) onImagesUpdated,
}) {
  List<AssetEntity> selectedAssets = []; // ✅ yeh internal hoga
  List<Uint8List> selectedBytes = List.from(alreadySelectedImages);

  return showModalBottomSheet(
    enableDrag: false,
    useSafeArea: true,
    isScrollControlled: true,
    context: context,
    builder: (context) {
      return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            titleSpacing: -2.w,
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
                  onPressed: () async {
                    if (selectedAssets.isEmpty && selectedBytes.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please Select Image"),
                          duration: Duration(milliseconds: 2000),
                        ),
                      );
                    } else {
                      List<Uint8List> converted = [];
                      for (var asset in selectedAssets) {
                        final data = await asset.originBytes;
                        if (data != null) converted.add(data);
                      }

                      final merged = [...selectedBytes, ...converted];

                      onImagesUpdated(merged);
                      Navigator.pop(context);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              FetchFile(selectedFiles: merged),
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
              indicatorSize: TabBarIndicatorSize.label,
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
                  selectedAssets = files;
                },
                previouslySelected: [],
              ),
              const PdfScreen(),
            ],
          ),
        ),
      );
    },
  );
}
