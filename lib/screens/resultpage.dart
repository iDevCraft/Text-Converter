import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter/services.dart';
import 'package:text_converter/helper/string_images.dart';
import 'package:text_converter/widgets/customDialogBox.dart';

class Resultpage extends StatefulWidget {
  final List<Uint8List> images;
  final List<String> extractedTexts;

  const Resultpage({
    super.key,
    required this.images,
    required this.extractedTexts,
  });

  @override
  State<Resultpage> createState() => _ResultpageState();
}

class _ResultpageState extends State<Resultpage> {
  PageController pageController = PageController();
  int currentTabIndex = 0;
  int currentImageIndex = 0;

  void onTabTapped(int index) {
    setState(() {
      currentTabIndex = index;
      pageController.jumpToPage(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    String allText = widget.extractedTexts.join("\n\n");

    return Scaffold(
      appBar: AppBar(
        titleSpacing: -2.w,
        leading: IconButton(
          onPressed: () {
            setState(() {
              final text = "Are You Sure?";
              showDialogBox(context, text);
            });
          },
          icon: Image.asset(back),
        ),
        title: Row(
          children: [
            Image.asset(txt_component, scale: 8.sp),
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
      ),
      body: Container(
        color: const Color(0xff2b2b2b),
        child: Column(
          children: [
            SizedBox(
              height: 25.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.images.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        currentImageIndex = index;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.all(3.w),
                      width: 30.w,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: currentImageIndex == index
                              ? Colors.blue
                              : Colors.transparent,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Image.memory(
                        widget.images[index],
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),

            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  top: 15.sp,
                  left: 15.sp,
                  right: 15.sp,
                  bottom: 20.sp,
                ),
                child: Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 5.h),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.sp),
                        color: const Color(0xff404040),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 2.h, bottom: 1.h),
                                child: DefaultTabController(
                                  length: 2,
                                  child: TabBar(
                                    onTap: onTabTapped,
                                    indicatorSize: TabBarIndicatorSize.label,
                                    labelPadding: EdgeInsets.only(left: 5.w),
                                    indicatorColor: Color(0xff9f9f9f),
                                    labelStyle: GoogleFonts.inter(
                                      fontSize: 16.sp,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    isScrollable: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    tabs: [Text("Page By Page"), Text("All")],
                                  ),
                                ),
                              ),
                              // Container(
                              //   margin: EdgeInsets.only(
                              //     top: 2.h,
                              //     bottom: 1.h,
                              //     left: 3.w,
                              //   ),
                              //   child: Text("data"),
                              // ),
                            ],
                          ),

                          Expanded(
                            child: PageView(
                              controller: pageController,
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                SingleChildScrollView(
                                  padding: EdgeInsets.all(3.w),
                                  child: Text(
                                    widget.extractedTexts[currentImageIndex]
                                            .trim()
                                            .isEmpty
                                        ? "No text detected"
                                        : widget
                                              .extractedTexts[currentImageIndex],
                                    style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                ),

                                SingleChildScrollView(
                                  padding: EdgeInsets.all(3.w),
                                  child: Text(
                                    allText.trim().isEmpty
                                        ? "No text detected"
                                        : allText,
                                    style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    Positioned(
                      left: 30.w,
                      bottom: 2.h,
                      width: 35.w,
                      height: 7.h,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () {
                          String textToCopy = currentTabIndex == 0
                              ? widget.extractedTexts[currentImageIndex]
                              : allText;
                          Clipboard.setData(ClipboardData(text: textToCopy));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Text copied to clipboard"),
                            ),
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(copytext),
                            Text(
                              "Copy Text",
                              style: GoogleFonts.inter(
                                fontSize: 16.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
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
