import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:text_converter/helper/string_images.dart';

class Resultpage extends StatefulWidget {
  final List<Uint8List> images;
  const Resultpage({super.key, required this.images});

  @override
  State<Resultpage> createState() => _ResultpageState();
}

class _ResultpageState extends State<Resultpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_vert, color: Colors.white),
          ),
        ],
      ),
      body: Container(
        color: Color(0xff2b2b2b),
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            Container(
              color: Colors.transparent,
              height: 25.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.images.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.all(3.w),
                    width: 30.w,
                    height: 15.h,
                    child: Card(
                      child: Image.memory(
                        widget.images[index],
                        fit: BoxFit.fill,
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(15.sp),
                child: Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 5.h),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.sp),
                        color: Color(0xff404040),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 2.h),
                                child: DefaultTabController(
                                  length: 2,
                                  child: TabBar(
                                    indicatorSize: TabBarIndicatorSize.label,
                                    labelPadding: EdgeInsets.only(left: 5.w),
                                    indicatorColor: Color(0xff9f9f9f),
                                    labelStyle: GoogleFonts.inter(
                                      fontSize: 16.sp,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    isScrollable: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    tabs: [Text("Page By Page"), Text("All")],
                                  ),
                                ),
                              ),
                              Spacer(),
                              Container(
                                margin: EdgeInsets.only(top: 2.h, right: 7.w),
                                child: Text(
                                  "01/02 Pages",
                                  style: GoogleFonts.inter(
                                    fontSize: 15.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 30.w,
                      height: 7.h,
                      bottom: 2.h,
                      width: 36.w,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () {},
                        child: Container(
                          margin: EdgeInsets.only(top: 1.h),
                          child: Column(
                            children: [
                              Image.asset(copytext),
                              Text(
                                "Copy Text",
                                style: GoogleFonts.inter(
                                  fontSize: 16.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
