import 'package:firebase_auth/firebase_auth.dart';
import 'package:uta_library/tools/firebase_auth_error_message.dart';

class Auth {
  final _authInstance = FirebaseAuth.instance;

  void reloadUserData() async {
    //will reload current user with change in user state.
    await _authInstance.currentUser!.reload();
  }

  //Listen to the user state => user == null || user.
  Stream<User?> get stream => _authInstance.userChanges();

  Future<User?> register(String email, String password) async {
    try {
      UserCredential userCredential =
          await _authInstance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // If registration is successful them send account activation link to the registered email address
      await userCredential.user!.sendEmailVerification();

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      // Send error with specific message according to the error codes from firebase
      throw FirebaseAuthErrorMessage(e.code).message;
    }
  }

  Future<User?> login(String email, String password) async {
    try {
      UserCredential userCredential =
          await _authInstance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      // Send error with specific message according to the error codes from firebase
      throw FirebaseAuthErrorMessage(e.code).message;
    }
  }

  Future<void> forgetPassword(String email) async {
    try {
      // Send password reset link to provided email address
      await _authInstance.sendPasswordResetEmail(
        email: email,
      );
    } on FirebaseAuthException catch (e) {
      // If invalid email or unregistered email then send error
      throw FirebaseAuthErrorMessage(e.code).message;
    }
  }

  Future<void> logout() async {
    await _authInstance.signOut();
  }
}
