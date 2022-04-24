import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uta_library/tools/custom_size.dart';

class CustomErrorDialog {
  static void dailyLimit(BuildContext context, int i) {
    Platform.isIOS
        ? showCupertinoDialog(
            barrierDismissible: true,
            context: context,
            builder: (ctx) {
              return CupertinoAlertDialog(
                title: Text(
                  "Daily Limit reached",
                  style: GoogleFonts.lato(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: customSize(context).height * 0.022,
                  ),
                ),
                content: Text(
                  "Sorry, you cannot book more than 180 minutes in a day!!",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                    fontWeight: FontWeight.bold,
                    fontSize: customSize(context).height * 0.02,
                  ),
                ),
              );
            })
        : showDialog(
            barrierDismissible: true,
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: Text(
                  "Daily Limit reached",
                  style: GoogleFonts.lato(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: customSize(context).height * 0.022,
                  ),
                ),
                content: Text(
                  "Sorry, you cannot book more than 180 minutes in a day!!",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                    fontWeight: FontWeight.bold,
                    fontSize: customSize(context).height * 0.02,
                  ),
                ),
              );
            });
  }

  static void timeConflict(BuildContext context) {
    Platform.isIOS
        ? showCupertinoDialog(
            barrierDismissible: true,
            context: context,
            builder: (ctx) {
              return CupertinoAlertDialog(
                title: Text(
                  "Time Conflict",
                  style: GoogleFonts.lato(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: customSize(context).height * 0.022,
                  ),
                ),
                content: Text(
                  "Sorry, you have already booked another room for same time!!",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                    fontWeight: FontWeight.bold,
                    fontSize: customSize(context).height * 0.02,
                  ),
                ),
              );
            })
        : showDialog(
            barrierDismissible: true,
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: Text(
                  "Time Conflict",
                  style: GoogleFonts.lato(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: customSize(context).height * 0.022,
                  ),
                ),
                content: Text(
                  "Sorry, you have already booked another room for same time!!",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                    fontWeight: FontWeight.bold,
                    fontSize: customSize(context).height * 0.02,
                  ),
                ),
              );
            });
  }
}
