import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

Future<void> showDialogBox(BuildContext context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "WARNING!",
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "You Want to Discard\nImport?",

              style: GoogleFonts.inter(
                fontSize: 16.sp,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 20.w,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1.5, color: Color(0Xff6e6e6e)),
                      borderRadius: BorderRadiusGeometry.circular(18),
                    ),
                  ),
                  onPressed: () {},
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
                width: 20.w,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1.5, color: Color(0Xff6e6e6e)),
                      borderRadius: BorderRadiusGeometry.circular(18),
                    ),
                  ),
                  onPressed: () {},
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
