import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:text_converter/screens/import_file.dart';

Future<void> showDialogBox(BuildContext context, String text) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: const Color(0xFF2B2B2B), // dark theme look
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Center(
          child: Text(
            "WARNING!",
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        content: Text(
          text,
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 23.w,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        width: 1.5,
                        color: Color(0Xff6e6e6e),
                      ),
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "No",
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 15.w),
              SizedBox(
                width: 23.w,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        width: 1.5,
                        color: Color(0Xff6e6e6e),
                      ),
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context); // dialog close
                    Navigator.popUntil(
                      context,
                      (route) => route.isFirst,
                    ); // home pe le jao
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ImportFile(),
                      ),
                    );
                  },
                  child: Text(
                    "Yes",
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}
