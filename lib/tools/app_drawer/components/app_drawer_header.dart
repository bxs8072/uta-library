import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uta_library/api/auth.dart';
import 'package:uta_library/models/user.dart';
import 'package:uta_library/tools/custom_size.dart';

class AppDrawerHeader extends StatelessWidget {
  final User user;
  const AppDrawerHeader({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        user.photo == ""
            ? Container(
                width: MediaQuery.of(context).size.height * 0.15,
                height: MediaQuery.of(context).size.height * 0.15,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  user.initial,
                  style: GoogleFonts.lato(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.height * 0.07,
                    letterSpacing: 1.5,
                  ),
                ),
              )
            : ClipOval(
                child: Material(
                  color: Colors.transparent,
                  child: Ink.image(
                    image: NetworkImage(user.photo!),
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.height * 0.15,
                    height: MediaQuery.of(context).size.height * 0.15,
                    child: const InkWell(),
                  ),
                ),
              ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Hello, " + user.firstName,
            style: GoogleFonts.lato(
              letterSpacing: 1,
              fontWeight: FontWeight.bold,
              fontSize: customSize(context).height * 0.025,
            ),
          ),
        ),
        CupertinoButton(
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
                          onPressed: () => Auth().logout().then(
                                (value) => Navigator.pop(ctx),
                              ),
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.logout),
              SizedBox(width: 10),
              Text("Logout"),
            ],
          ),
        ),
        const SizedBox(
          child: Divider(
            thickness: 2,
          ),
        ),
      ],
    );
  }
}
