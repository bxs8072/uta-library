import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uta_library/models/user.dart';
import 'package:uta_library/pages/profile_page/profile_page.dart';
import 'package:uta_library/pages/room_booked_page/room_booked_page.dart';
import 'package:uta_library/screens/home_screen/home_screen.dart';
import 'package:uta_library/screens/landing_screen/landing_screen.dart';
import 'package:uta_library/tools/app_drawer/components/app_drawer_header.dart';
import 'package:uta_library/tools/custom_navigator.dart';
import 'package:uta_library/tools/theme_tools.dart';
import 'package:uta_library/uis/history_ui/history_ui.dart';
import 'package:uta_library/uis/notifications_ui/notifications_ui.dart';

class AppDrawer extends StatelessWidget {
  final User user;
  const AppDrawer({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: AppDrawerHeader(user: user),
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.dark_mode),
                    title: Text(
                      "Dark Mode",
                      style: GoogleFonts.lato(),
                    ),
                    trailing: Switch(
                      activeColor: ThemeTools.secondaryColor,
                      onChanged: (val) {
                        ThemeTools.changeTheme(context);
                      },
                      value: ThemeTools.isDarkMode(context),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.dashboard),
                    title: Text(
                      "Dashboard",
                      style: GoogleFonts.lato(),
                    ),
                    onTap: () {
                      customReplaceNavigator(
                        context,
                        LandingScreen(key: key),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.notifications),
                    title: Text(
                      "Notifications",
                      style: GoogleFonts.lato(),
                    ),
                    onTap: () {
                      customNavigator(
                        context,
                        NotificationsUI(user: user, key: key),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.calendar_today),
                    title: Text(
                      "Room Booked",
                      style: GoogleFonts.lato(),
                    ),
                    onTap: () {
                      customNavigator(
                        context,
                        RoomBookedPage(
                          user: user,
                          key: key,
                          canPop: true,
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.history),
                    title: Text(
                      "History",
                      style: GoogleFonts.lato(),
                    ),
                    onTap: () {
                      customNavigator(
                        context,
                        HistoryUI(user: user, key: key),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
