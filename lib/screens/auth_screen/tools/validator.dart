import 'package:email_validator/email_validator.dart';
import 'package:password_strength/password_strength.dart';

class Validator {
  static String studentDomain = "mavs.uta.edu";
  static String staffDomain = "uta.edu";

  final String? text;

  Validator(this.text);

  String? email() {
    bool _isValidEmail = EmailValidator.validate(text!);

    bool _isValidUtaEmail =
        text!.toLowerCase().split('@').contains(Validator.studentDomain) ||
            text!.toLowerCase().split('@').contains(Validator.staffDomain);
    if (!_isValidEmail) {
      return "Please enter valid email address";
    } else if (!_isValidUtaEmail) {
      return "You can only use UTA email address.";
    } else {
      return null;
    }
  }

  String? password() {
    double strength = estimatePasswordStrength(text!);

    if (strength < 0.3) {
      return "Password is too weak. Please enter password with atleast on uppercase and special symbol";
    }
    return null;
  }
}
