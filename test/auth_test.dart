import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';

final mockUser = MockUser(
  isAnonymous: false,
  uid: 'T3STU1D',
  email: 'email@mavs.uta.edu',
  displayName: 'Bhuwan Shrestha',
  phoneNumber: '9999999999',
  photoURL: 'http://photos.url/bobbie.jpg',
  refreshToken: 'some_long_token',
);

void main() {
  test('Returns null if user is not signed in', () async {
    final auth = MockFirebaseAuth();
    final user = auth.currentUser;
    expect(user, isNull);
  });

  group('Emits an initial User? on startup.', () {
    test('Returns null if user is signed out', () async {
      final auth = MockFirebaseAuth();
      expect(auth.authStateChanges(), emits(null));
    });

    test('Returns user if user is signed in', () async {
      final auth = MockFirebaseAuth(signedIn: true);
      expect(auth.authStateChanges(), emitsInOrder([isA<User>()]));
      expect(auth.userChanges(), emitsInOrder([isA<User>()]));
    });
  });

  test('Sign in with email and password', () async {
    final auth = MockFirebaseAuth(mockUser: mockUser);
    final result = await auth.signInWithEmailAndPassword(
        email: 'email@mavs.uta.edu', password: 'password#123');
    final user = result.user;
    expect(user, mockUser);
    expect(auth.authStateChanges(), emitsInOrder([null, isA<User>()]));
    expect(auth.userChanges(), emitsInOrder([null, isA<User>()]));
  });

  test('Returns a mocked user if user is already signed in', () async {
    final auth = MockFirebaseAuth(signedIn: true, mockUser: mockUser);
    final user = auth.currentUser;
    expect(user, mockUser);
  });

  test('Returns null after user is sign out', () async {
    final auth = MockFirebaseAuth(signedIn: true, mockUser: mockUser);
    final user = auth.currentUser;

    await auth.signOut();

    expect(auth.currentUser, isNull);
    expect(auth.authStateChanges(), emitsInOrder([user, null]));
    expect(auth.userChanges(), emitsInOrder([user, null]));
  });

  test('Reload user after some changes in background', () async {
    final auth = MockFirebaseAuth(signedIn: true);
    final user = auth.currentUser;
    expect(user, isNotNull);
    // Does not throw an exception.
    await user!.reload();
  });
}

class FakeAuthCredential implements AuthCredential {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
