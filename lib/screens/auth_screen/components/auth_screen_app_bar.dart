import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:uta_library/tools/theme_tools.dart';

class AuthScreenAppBar extends StatelessWidget {
  const AuthScreenAppBar({Key? key}) : super(key: key);

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
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
      foregroundColor: ThemeTools.appBarForeGroundColor(context),
      backgroundColor: Colors.transparent,
      pinned: true,
      actions: [
        IconButton(
          onPressed: () {
            ThemeProvider.controllerOf(context).nextTheme();
          },
          icon: Icon(
            ThemeTools.isDarkMode(context) ? Icons.light_mode : Icons.dark_mode,
          ),
          color: ThemeTools.appBarForeGroundColor(context),
        ),
      ],
    );
  }
}
