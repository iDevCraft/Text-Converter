import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter/services.dart';

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
        title: Text(
          "EXTRACTOR",
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        color: const Color(0xff2b2b2b),
        child: Column(
          children: [
            // Thumbnail List
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
                              ? Colors.teal
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
                padding: EdgeInsets.all(15.sp),
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
                          Container(
                            child: DefaultTabController(
                              length: 2,
                              initialIndex: currentTabIndex,
                              child: TabBar(
                                onTap: onTabTapped,
                                indicatorSize: TabBarIndicatorSize.label,
                                indicatorColor: Colors.white,
                                labelStyle: GoogleFonts.inter(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                                isScrollable: true,
                                tabs: [
                                  Tab(text: "Page By Page"),
                                  Tab(text: "All"),
                                ],
                              ),
                            ),
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
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),

                                SingleChildScrollView(
                                  padding: EdgeInsets.all(3.w),
                                  child: Text(
                                    allText.trim().isEmpty
                                        ? "No text detected"
                                        : allText,
                                    style: const TextStyle(color: Colors.white),
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
                      bottom: 1.h,
                      width: 36.w,
                      height: 7.h,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
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
                            const Icon(Icons.copy, color: Colors.white),
                            Text(
                              "Copy Text",
                              style: GoogleFonts.inter(
                                fontSize: 15.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
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
