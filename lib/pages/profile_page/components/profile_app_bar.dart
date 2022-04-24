import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uta_library/api/auth.dart';
import 'package:uta_library/tools/theme_tools.dart';

class ProfileAppBar extends StatelessWidget {
  const ProfileAppBar({Key? key}) : super(key: key);

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
              text: 'Pro',
              style: GoogleFonts.lato(
                fontWeight: FontWeight.bold,
                color: ThemeTools.primaryColor,
              ),
            ),
            TextSpan(
              text: 'file',
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
      actions: [
        IconButton(
            onPressed: () {
              Platform.isIOS
                  ? showCupertinoDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (ctx) => CupertinoAlertDialog(
                        title: const Text("Are you sure?"),
                        content: const Text("Do you want to logout?"),
                        actions: [
                          CupertinoDialogAction(
                            onPressed: () => Auth().logout().then(
                                  (value) => Navigator.pop(ctx),
                                ),
                            child: const Text("Yes"),
                          ),
                          CupertinoDialogAction(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text("No"),
                          ),
                        ],
                      ),
                    )
                  : showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (ctx) => AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        title: const Text("Are you sure?"),
                        content: const Text("Do you want to logout?"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Auth()
                                  .logout()
                                  .then((value) => Navigator.pop(ctx));
                            },
                            child: const Text("Yes"),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text("No"),
                          ),
                        ],
                      ),
                    );
            },
            icon: const Icon(Icons.logout)),
      ],
    );
  }
}
