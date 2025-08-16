import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:text_converter/helper/string_images.dart';
import 'package:text_converter/widgets/custom_bottomsheet.dart';

class ImportFile extends StatefulWidget {
  const ImportFile({super.key});

  @override
  State<ImportFile> createState() => _ImportFileState();
}

class _ImportFileState extends State<ImportFile> {
  List<Uint8List> selectedImages = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Image.asset(back),
        ),
        titleSpacing: -2.w,
        title: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(appbar_image),
                  SizedBox(width: 2.w),
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Color(0xFF2b2b2b),
                      ),
                      height: 4.5.h,

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,

                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 2.w),
                            child: Text(
                              "Import File First",
                              style: GoogleFonts.inter(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Spacer(),
                          IconButton(
                            onPressed: () async {
                              if (!mounted) return;
                              customBottomSheet(
                                context: context,
                                alreadySelectedImages: selectedImages,
                                onImagesUpdated: (updatedList) {
                                  setState(() {
                                    selectedImages =
                                        updatedList; // 👈 Update local list
                                  });
                                },
                              );
                            },
                            icon: Image.asset(attachFile),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.more_vert))],
      ),

      body: Center(
        child: Container(
          color: lightGrey,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  customBottomSheet(
                    context: context,
                    alreadySelectedImages: selectedImages,
                    onImagesUpdated: (updatedList) {
                      setState(() {
                        selectedImages = updatedList; // 👈 Update local list
                      });
                    },
                  );
                },
                child: Column(
                  children: [
                    Image.asset(importFileFirst),
                    SizedBox(height: 2.h),
                    Text(
                      "Import File",
                      style: GoogleFonts.inter(
                        fontSize: 18.sp,
                        color: Color(0xFF555555),
                        fontWeight: FontWeight.bold,
                      ),
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
