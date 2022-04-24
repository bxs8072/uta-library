import 'package:flutter_test/flutter_test.dart';
import 'package:uta_library/screens/auth_screen/tools/validator.dart';

void main() {
  group('Emits true if email is valid else false.', () {
    test('Returns true if valid', () async {
      final validator = Validator("email@mavs.uta.edu");
      expect(validator.email(), isNull);
    });

    test('Returns false if valid', () async {
      final validator = Validator("email@mavs");
      expect(validator.email(), isNotNull);
    });
  });

  group('Emits true if email is valid else false.', () {
    test('Returns true if valid', () async {
      final validator = Validator("email@mavs.uta.edu");
      expect(validator.email(), isNull);
    });

    test('Returns false if valid', () async {
      final validator = Validator("email@mavs");
      expect(validator.email(), isNotNull);
    });
  });
}
