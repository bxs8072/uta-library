import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uta_library/models/user.dart';
import 'package:uta_library/pages/profile_page/components/edit_name_dialog.dart';
import 'package:uta_library/pages/profile_page/components/profile_app_bar.dart';
import 'package:uta_library/pages/profile_page/components/profile_picture.dart';
import 'package:uta_library/tools/custom_navigator.dart';
import 'package:uta_library/tools/custom_size.dart';
import 'package:uta_library/tools/theme_tools.dart';
import 'package:uta_library/uis/history_ui/history_ui.dart';

class ProfilePage extends StatefulWidget {
  final User user;
  const ProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        ProfileAppBar(key: widget.key),
        SliverPadding(
          padding: const EdgeInsets.all(12.0),
          sliver: SliverToBoxAdapter(
            child: ProfilePicture(user: widget.user),
          ),
        ),

        SliverToBoxAdapter(
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: GoogleFonts.roboto(
                  fontSize: customSize(context).height * 0.025,
                  color: ThemeTools.appBarForeGroundColor(context),
                  letterSpacing: 1.5),
              children: <TextSpan>[
                TextSpan(
                  text: widget.user.email.split('@')[0] + "@",
                  style: GoogleFonts.lato(
                    fontWeight: FontWeight.bold,
                    color: ThemeTools.primaryColor,
                  ),
                ),
                TextSpan(
                  text: widget.user.email.split('@')[1],
                  style: GoogleFonts.lato(
                    fontWeight: FontWeight.bold,
                    color: ThemeTools.secondaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: 25),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          sliver: SliverToBoxAdapter(
            child: Card(
              child: ListTile(
                title: Text(widget.user.fullName),
                trailing: IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (ctx) => EditNameDialog(user: widget.user),
                        enableDrag: true,
                      );
                    },
                    icon: const Icon(Icons.edit)),
              ),
            ),
          ),
        ),
        // SliverPadding(
        //   padding: EdgeInsets.symmetric(horizontal: 12),
        //   sliver: SliverToBoxAdapter(
        //     child: Card(
        //       child: ListTile(
        //         title: Text("Change Password"),
        //         trailing: IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
        //       ),
        //     ),
        //   ),
        // ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          sliver: SliverToBoxAdapter(
            child: Card(
              child: ListTile(
                title: const Text("History"),
                trailing: const Icon(Icons.history),
                onTap: () {
                  // Navigate to order history UI
                  customNavigator(
                      context,
                      HistoryUI(
                        key: widget.key,
                        user: widget.user,
                      ));
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
