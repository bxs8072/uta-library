import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uta_library/models/user.dart';
import 'package:uta_library/tools/custom_navigator.dart';
import 'package:uta_library/tools/theme_tools.dart';
import 'package:uta_library/uis/notifications_ui/notifications_ui.dart';

class DashboardAppBar extends StatelessWidget {
  final User user;
  const DashboardAppBar({Key? key, required this.user}) : super(key: key);

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
                color: ThemeTools.secondaryColor,
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
      foregroundColor: ThemeTools.appBarForeGroundColor(context),
      pinned: true,
      actions: [
        IconButton(
          onPressed: () {
            // Navigate to Notification UI
            customNavigator(context, NotificationsUI(user: user));
          },
          icon: Icon(
            Icons.notifications,
            color: ThemeTools.appBarForeGroundColor(context),
          ),
        ),
      ],
    );
  }
}
