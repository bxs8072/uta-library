import 'package:flutter/material.dart';
import 'package:uta_library/api/auth.dart';
import 'package:uta_library/tools/theme_tools.dart';

class EmailVerificationCard extends StatelessWidget {
  const EmailVerificationCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //render the email verification dialog if user is not verified before user can go to the home screen
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        SliverAppBar(
          title: const Text("Verify your account"),
          backgroundColor: Colors.transparent,
          foregroundColor: ThemeTools.appBarForeGroundColor(context),
          actions: [
            IconButton(
              onPressed: Auth().logout,
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        const SliverToBoxAdapter(
          child: Text("Check you email inbox to verify the account"),
        ),
      ],
    ));
  }
}
