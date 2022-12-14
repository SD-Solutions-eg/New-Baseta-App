import 'dart:convert';
import 'dart:developer';
import 'dart:math' show Random;

import 'package:allin1/data/services/firebase_auth_services.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseRepository {
  final FirebaseAuthenticationServices _firebaseServices;
  FirebaseRepository(this._firebaseServices);
  final id = DateTime.now().second ~/ 1000;

  Future<User> login({required String email, required String password}) async {
    try {
      final firebaseUser = await _firebaseServices.signIn(email, password);

      return firebaseUser;
    } catch (e) {
      rethrow;
    }
  }

  Future<User> register(
      {required String email, required String password}) async {
    try {
      final firebaseUser = await _firebaseServices.signUp(email, password);

      return firebaseUser;
    } catch (e) {
      rethrow;
    }
  }

  Future<UserCredential> appleSignIn() async {
    try {
      // To prevent replay attacks with the credential returned from Apple, we
      // include a nonce in the credential request. When signing in with
      // Firebase, the nonce in the id token returned by Apple, is expected to
      // match the sha256 hash of `rawNonce`.
      final rawNonce = _generateNonce();
      final nonce = _sha256ofString(rawNonce);
      final userCredentials = await _firebaseServices.loginWithApple(
          rawNonce: rawNonce, nonce: nonce);
      return userCredentials;
    } catch (e) {
      rethrow;
    }
  }

  /// Generates a cryptographically secure random nonce, to be included in a
  /// credential request.
  String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<UserCredential> googleSignIn() async {
    try {
      final userCredentials = await _firebaseServices.loginWithGoogle();

      return userCredentials;
    } catch (e) {
      rethrow;
    }
  }

  Future<UserCredential> facebookSignIn() async {
    try {
      final userCredentials = await _firebaseServices.loginWithFacebook();

      return userCredentials;
    } catch (e) {
      log('Facebook Error: $e');
      rethrow;
    }
  }

  Stream<User?> isSignedIn() async* {
    yield* _firebaseServices.isSignedIn();
  }

  Future<bool> isVerified() async {
    try {
      return _firebaseServices.isVerified();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> sendEmailVerification() async {
    try {
      await _firebaseServices.sendEmailVerification();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteUser() async {
    try {
      await _firebaseServices.deleteUser();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logOut() async {
    try {
      await _firebaseServices.logOut();
    } catch (e) {
      rethrow;
    }
  }
}
