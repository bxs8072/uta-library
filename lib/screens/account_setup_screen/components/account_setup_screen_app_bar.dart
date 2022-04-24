import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uta_library/tools/theme_tools.dart';

class AccountSetupScreenAppBar extends StatelessWidget {
  const AccountSetupScreenAppBar({Key? key}) : super(key: key);

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
              text: 'Mav ',
              style: GoogleFonts.lato(
                fontWeight: FontWeight.bold,
                color: ThemeTools.primaryColor,
              ),
            ),
            TextSpan(
              text: 'Study',
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
