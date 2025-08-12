import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:text_converter/helper/string_images.dart';
import 'package:text_converter/screens/resultpage.dart';

class FetchFile extends StatefulWidget {
  final List<Uint8List> selectedFiles;
  const FetchFile({super.key, required this.selectedFiles});

  @override
  State<FetchFile> createState() => _FetchFileState();
}

class _FetchFileState extends State<FetchFile> {
  List<dynamic> fetchingFiles = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(appbar_image),
                  SizedBox(width: 2.w),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Color(0xFF2b2b2b),
                    ),
                    height: 4.h,
                    width: 45.w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,

                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 2.w),
                          child: Text(
                            "File Imported",
                            style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Spacer(),
                        Container(
                          margin: EdgeInsets.only(right: 2.w),
                          child: Image.asset(tick),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.more_vert))],
      ),
      body: Container(
        width: double.infinity,
        color: lightGrey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 25.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.selectedFiles.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.all(3.w),
                    width: 30.w,
                    height: 15.h,
                    child: Card(
                      child: Image.memory(
                        widget.selectedFiles[index],
                        fit: BoxFit.fill,
                      ),
                    ),
                  );
                },
              ),
            ),

            Container(
              margin: EdgeInsets.only(top: 20.h),
              child: Text(
                "Press Button to\nExtract Text",
                style: GoogleFonts.inter(
                  fontSize: 18.sp,
                  color: grey,
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 25.h, right: 3.w),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff1A5ABB),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return Resultpage(images: widget.selectedFiles);
                            },
                          ),
                        );
                      });
                    },
                    child: Row(
                      children: [
                        Text(
                          "Extract",
                          style: GoogleFonts.inter(
                            fontSize: 16.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Image.asset(convert),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
