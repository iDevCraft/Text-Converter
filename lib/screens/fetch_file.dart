import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:text_converter/helper/string_images.dart';
import 'package:text_converter/screens/resultpage.dart';
import 'package:text_converter/screens/text_detect/text_detector.dart';
import 'package:text_converter/widgets/customDialogBox.dart';
import 'package:text_converter/widgets/custom_bottomsheet.dart';

class FetchFile extends StatefulWidget {
  final List<Uint8List> selectedFiles;
  const FetchFile({super.key, required this.selectedFiles});

  @override
  State<FetchFile> createState() => _FetchFileState();
}

class _FetchFileState extends State<FetchFile> {
  bool isExtracting = false;
  TextDetectorHelper textDetectorHelper = TextDetectorHelper();

  late List<Uint8List> selectedImages;

  @override
  void initState() {
    super.initState();
    selectedImages = List.from(widget.selectedFiles);
  }

  Future<void> _extractText() async {
    setState(() {
      isExtracting = true;
    });

    try {
      final resultList = await textDetectorHelper.getRecognizedTexts(
        selectedImages,
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              Resultpage(images: selectedImages, extractedTexts: resultList),
        ),
      );
    } catch (e) {
      print("Error extracting text: $e");
    } finally {
      setState(() {
        isExtracting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0.w,
        leading: IconButton(
          onPressed: () {
            final text = "You Want to Discard\nImport?";
            showDialogBox(context, text);
          },
          icon: Image.asset(back),
        ),
        title: Row(
          children: [
            Image.asset(appbar_image),
            SizedBox(width: 2.w),
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: const Color(0xFF2b2b2b),
                ),
                height: 4.h,
                child: Row(
                  children: [
                    SizedBox(width: 2.w),
                    Text(
                      "File Imported",
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: EdgeInsets.only(right: 2.w),
                      child: Image.asset(tick),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        actions: [
          PopupMenuButton(
            color: lightgrey,
            itemBuilder: (context) => [
              PopupMenuItem(child: Text("data")),
              PopupMenuItem(child: Text("data2")),
            ],
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        color: lightgrey,
        child: Column(
          children: [
            SizedBox(
              height: 25.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: selectedImages.length + 1,
                itemBuilder: (context, index) {
                  if (index == selectedImages.length) {
                    return InkWell(
                      onTap: () {
                        customBottomSheet(
                          context: context,
                          alreadySelectedImages: selectedImages,
                          onImagesUpdated: (updatedList) {
                            setState(() {
                              final newSet = <String, Uint8List>{};
                              for (var img in selectedImages) {
                                newSet[String.fromCharCodes(img)] = img;
                              }
                              for (var img in updatedList) {
                                newSet[String.fromCharCodes(img)] = img;
                              }
                              selectedImages = newSet.values.toList();
                            });
                          },
                        );
                      },

                      child: Container(
                        margin: EdgeInsets.all(3.w),
                        width: 30.w,
                        height: 15.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey, width: 2),
                          color: Colors.white10,
                        ),
                        child: Center(
                          child: Icon(Icons.add, color: blue, size: 30.sp),
                        ),
                      ),
                    );
                  } else {
                    return Container(
                      margin: EdgeInsets.all(3.w),
                      width: 30.w,
                      height: 15.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey, width: 2),
                        color: Colors.white10,
                      ),
                      child: Image.memory(
                        selectedImages[index],
                        fit: BoxFit.cover,
                      ),
                    );
                  }
                },
              ),
            ),

            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  isExtracting
                      ? "Please Wait..."
                      : "Press Button to\nExtract Text",
                  style: GoogleFonts.inter(
                    fontSize: 18.sp,
                    color: grey,
                    fontWeight: FontWeight.w800,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            Expanded(
              child: Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  margin: EdgeInsets.only(bottom: 7.h, right: 5.w),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      elevation: 0,
                    ),
                    onPressed: _extractText,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          isExtracting ? "Extracting" : "Extract",
                          style: GoogleFonts.inter(
                            fontSize: 16.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        isExtracting
                            ? SizedBox(
                                height: 2.h,
                                width: 2.h,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Image.asset(convert, color: Colors.white),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
