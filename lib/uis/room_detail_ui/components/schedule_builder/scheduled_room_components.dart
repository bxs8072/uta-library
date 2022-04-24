import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ScheduledRoomComponents {
  static Card isAvailableCircle(Color color) => Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        color: color,
        child: const SizedBox(
          height: 20,
          width: 20,
        ),
      );

  static Text timeText(String title) => Text(
        title,
        style: GoogleFonts.lato(
          fontWeight: FontWeight.bold,
        ),
      );
}
