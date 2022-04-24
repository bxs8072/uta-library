import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uta_library/tools/theme_tools.dart';

class ItemsUIAppBar extends StatelessWidget {
  const ItemsUIAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: RichText(
        text: TextSpan(
          style: GoogleFonts.lato(
            fontSize: ThemeTools.appBarTitleSize(context),
            color: ThemeTools.appBarForeGroundColor(context),
          ),
          children: <TextSpan>[
            TextSpan(
              text: 'Available',
              style: GoogleFonts.lato(
                fontWeight: FontWeight.bold,
                color: ThemeTools.primaryColor,
              ),
            ),
            TextSpan(
              text: ' Items',
              style: GoogleFonts.lato(
                fontWeight: FontWeight.bold,
                color: ThemeTools.secondaryColor,
              ),
            ),
          ],
        ),
      ),
      foregroundColor: ThemeTools.appBarForeGroundColor(context),
      backgroundColor: Colors.transparent,
      pinned: true,
    );
  }
}
