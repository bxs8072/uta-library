import 'package:firebase_auth/firebase_auth.dart' as fb;

class User {
  final String uid;
  final String email;
  final String? photo;
  final String firstName;
  final String lastName;

  User({
    required this.uid,
    required this.email,
    this.photo,
    required this.firstName,
    required this.lastName,
  });

  //Convert User model into JSON Object
  Map<String, dynamic> toJson() => {
        "uid": uid,
        "email": email,
        "photo": photo,
        "firstName": firstName,
        "lastName": lastName,
      };

  //Get Initial from user first name and last name
  String get initial => firstName[0].toUpperCase() + lastName[0].toUpperCase();

  //Get user full name
  String get fullName => firstName + " " + lastName;

// Convert FirebaseUser type to the User class Model
  factory User.fromFirebase(fb.User? user) => User(
        uid: user!.uid,
        email: user.email!,
        firstName: "",
        lastName: "",
        photo: user.photoURL,
      );

// Convert JSON object type to the User class Model
  factory User.fromJson(dynamic jsonData) => User(
        uid: jsonData["uid"],
        email: jsonData["email"],
        photo: jsonData["photo"] ?? "",
        firstName: jsonData["firstName"],
        lastName: jsonData["lastName"],
      );
}
