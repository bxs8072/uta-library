import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uta_library/models/user.dart' as user;
import 'package:uta_library/screens/account_setup_screen/components/account_setup_screen_app_bar.dart';
import 'package:uta_library/tools/custom_size.dart';
import 'package:uta_library/tools/theme_tools.dart';

class AccountSetupScreen extends StatefulWidget {
  final User user;
  const AccountSetupScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<AccountSetupScreen> createState() => _AccountSetupScreenState();
}

class _AccountSetupScreenState extends State<AccountSetupScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const AccountSetupScreenAppBar(),
          SliverPadding(
            padding: const EdgeInsets.all(12.0),
            sliver: SliverToBoxAdapter(
              child: Form(
                  child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Text(
                        "Account Setup",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.ubuntu(
                            fontSize: customSize(context).height * 0.045),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: _firstNameController,
                        decoration:
                            const InputDecoration(labelText: "First name"),
                        onChanged: (val) {
                          setState(() {});
                        },
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: _lastNameController,
                        decoration:
                            const InputDecoration(labelText: "Last name"),
                        onChanged: (val) {
                          setState(() {});
                        },
                      ),
                      const SizedBox(height: 15),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary:
                              ThemeTools.elevatedButtonBackGroundColor(context),
                        ),
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection("Users")
                              .doc(widget.user.uid)
                              .set(user.User(
                                uid: widget.user.uid,
                                email: widget.user.email!,
                                firstName: _firstNameController.text.trim(),
                                lastName: _lastNameController.text.trim(),
                              ).toJson());
                        },
                        child: Text(
                          "Submit",
                          style: GoogleFonts.lato(
                            color: ThemeTools.elevatedButtonForeGroundColor(
                                context),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
            ),
          ),
        ],
      ),
    );
  }
}
