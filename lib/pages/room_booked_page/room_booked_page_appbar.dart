import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uta_library/models/user.dart';
import 'package:uta_library/tools/theme_tools.dart';

class RoomBookedPageAppBar extends StatelessWidget {
  final User user;
  const RoomBookedPageAppBar({Key? key, required this.user}) : super(key: key);

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
              text: 'Room ',
              style: GoogleFonts.lato(
                fontWeight: FontWeight.bold,
                color: ThemeTools.primaryColor,
              ),
            ),
            TextSpan(
              text: 'Booked',
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
