import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uta_library/tools/theme_tools.dart';

class NotificationsUIAppBar extends StatelessWidget {
  const NotificationsUIAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      centerTitle: true,
      title: RichText(
        text: TextSpan(
          style: GoogleFonts.lato(
            fontSize: ThemeTools.appBarTitleSize(context),
            color: ThemeTools.appBarForeGroundColor(context),
          ),
          children: <TextSpan>[
            TextSpan(
              text: 'Notifi',
              style: GoogleFonts.lato(
                fontWeight: FontWeight.bold,
                color: ThemeTools.primaryColor,
              ),
            ),
            TextSpan(
              text: 'cations',
              style: GoogleFonts.lato(
                fontWeight: FontWeight.bold,
                color: ThemeTools.secondaryColor,
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
      foregroundColor: ThemeTools.appBarForeGroundColor(context),
      pinned: true,
    );
  }
}
