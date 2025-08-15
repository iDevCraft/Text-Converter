import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:text_converter/helper/string_images.dart';
import 'package:text_converter/screens/resultpage.dart';
import 'package:text_converter/screens/text_detect/text_detector.dart';
import 'package:text_converter/widgets/customDialogBox.dart';

class FetchFile extends StatefulWidget {
  final List<Uint8List> selectedFiles;
  const FetchFile({super.key, required this.selectedFiles});

  @override
  State<FetchFile> createState() => _FetchFileState();
}

class _FetchFileState extends State<FetchFile> {
  bool isExtracting = false;
  TextDetectorHelper textDetectorHelper = TextDetectorHelper();

  Future<void> _extractText() async {
    setState(() {
      isExtracting = true;
    });

    try {
      final resultList = await textDetectorHelper.getRecognizedTexts(
        widget.selectedFiles,
      );
      Navigator.push(
        (context),
        MaterialPageRoute(
          builder: (context) {
            return Resultpage(
              images: widget.selectedFiles,
              extractedTexts: resultList,
            );
          },
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
            setState(() {
              final text = "You Want to Discard\nImport?";
              showDialogBox(context, text);
            });
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
                        fontSize: 14.sp,
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
            color: lightGrey,
            itemBuilder: (context) => [
              PopupMenuItem(child: Text("data")),
              PopupMenuItem(child: Text("data2")),
            ],
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        color: lightGrey,
        child: Column(
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
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
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

            // Yaha se neeche button ko end me chipkane ka code
            Expanded(
              child: Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  margin: EdgeInsets.only(bottom: 7.h, right: 5.w),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff1A5ABB),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      _extractText();
                    },
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
