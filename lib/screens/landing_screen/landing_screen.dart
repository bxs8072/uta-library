import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uta_library/api/auth.dart';
import 'package:uta_library/screens/account_setup_screen/account_setup_screen.dart';
import 'package:uta_library/screens/auth_screen/auth_screen.dart';
import 'package:uta_library/screens/home_screen/home_screen.dart';
import 'package:uta_library/models/user.dart' as user;

class LandingScreen extends StatelessWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Auth _auth = Auth();
    return StreamBuilder<User?>(
      stream: _auth.stream,
      builder: (conttext, snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          // User is not logged in
          return AuthScreen(key: key);
        } else if (!snapshot.data!.emailVerified) {
          // Account is not activated
          return AlertDialog(
            title: const Text("Please verify your account."),
            content: const Text(
                "Account should be verified before you can use MavStudy. Please check your email to verify the account."),
            actions: [
              IconButton(
                onPressed: () {
                  _auth.reloadUserData();
                },
                icon: const Icon(Icons.refresh),
              ),
              TextButton(
                onPressed: () async {
                  await snapshot.data!
                      .sendEmailVerification()
                      .then((value) {})
                      .catchError((error) {});
                },
                child: const Text("Send Verification"),
              ),
              TextButton(
                onPressed: () {
                  Auth().logout();
                },
                child: const Text("Logout"),
              ),
            ],
          );
        } else {
          // User is logged in and account is verified
          return StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Users')
                  .doc(snapshot.data!.uid)
                  .snapshots(),
              builder: (context, snap) {
                if (!snap.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (!snap.data!.exists) {
                  // User account is not setup
                  return AccountSetupScreen(user: snapshot.data!);
                } else {
                  // User account is already setup
                  return HomeScreen(user: user.User.fromJson(snap.data));
                }
              });
        }
      },
    );
  }
}
