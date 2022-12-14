import 'dart:developer';

import 'package:allin1/core/constants/http_exception.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class FirebaseAuthenticationServices {
  final _firebaseAuth = FirebaseAuth.instance;
  final _facebookAuth = FacebookAuth.instance;
  final _googleSignIn = GoogleSignIn(scopes: ['email']);

  Future<User> signUp(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      if (user != null) {
        return user;
      } else {
        throw HttpException('Registration Failed');
      }
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.message);
    } catch (e) {
      log(e.toString());
      throw HttpException(e.toString());
    }
  }

  Future<User> signIn(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user != null) {
        return user;
      } else {
        throw HttpException('Failed to sign in');
      }
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.message);
    } catch (e) {
      log(e.toString());

      throw HttpException(e.toString());
    }
  }

  Future<void> sendEmailVerification() async {
    try {
      if (_firebaseAuth.currentUser != null) {
        await _firebaseAuth.currentUser!.sendEmailVerification();
      } else {
        throw HttpException('Current User is Null');
      }
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.message);
    } catch (e) {
      log(e.toString());

      throw HttpException(e.toString());
    }
  }

  Future<bool> isVerified() async {
    try {
      if (_firebaseAuth.currentUser != null) {
        await _firebaseAuth.currentUser!.reload();

        return _firebaseAuth.currentUser!.emailVerified;
      }
      throw 'Current user is Null';
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.message);
    } catch (e) {
      log(e.toString());

      throw HttpException(e.toString());
    }
  }

  Future<UserCredential> loginWithFacebook() async {
    try {
      final LoginResult loginResult = await _facebookAuth.login();

      log('facebook status: ${loginResult.status}');
      if (loginResult.status == LoginStatus.success) {
        final facebookCredential =
            FacebookAuthProvider.credential(loginResult.accessToken!.token);
        final firebaseCredential =
            await _firebaseAuth.signInWithCredential(facebookCredential);
        return firebaseCredential;
      } else if (loginResult.status == LoginStatus.failed) {
        throw HttpException('Failed to login with Facebook');
      } else {
        throw 'Cancelled';
      }
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.message);
    } catch (e) {
      log(e.toString());

      throw HttpException(e.toString());
    }
  }

  Future<UserCredential> loginWithApple(
      {required String rawNonce, required String nonce}) async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );
      final credentials =
          await _firebaseAuth.signInWithCredential(oauthCredential);
      return credentials;
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.message);
    } catch (e) {
      rethrow;
    }
  }

  Future<UserCredential> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? userAccount = await _googleSignIn.signIn();
      if (userAccount != null) {
        final GoogleSignInAuthentication googleSignInAuth =
            await userAccount.authentication;
        final userCredential = GoogleAuthProvider.credential(
          idToken: googleSignInAuth.idToken,
          accessToken: googleSignInAuth.accessToken,
        );

        final firebaseCredential =
            await _firebaseAuth.signInWithCredential(userCredential);

        return firebaseCredential;
      } else {
        throw 'CANCELLED';
      }
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.message);
    } catch (e) {
      log(e.toString());

      throw HttpException(e.toString());
    }
  }

  Future<void> changeFirebaseEmail(String newEmail) async {
    if (_firebaseAuth.currentUser != null) {
      try {
        await _firebaseAuth.currentUser!.updateEmail(newEmail);
      } on FirebaseAuthException catch (e) {
        throw FirebaseAuthException(code: e.code, message: e.message);
      } catch (e) {
        rethrow;
      }
    }
  }

  Stream<User?> isSignedIn() async* {
    yield* _firebaseAuth.authStateChanges();
  }

  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  Future<void> deleteUser() async {
    if (_firebaseAuth.currentUser != null) {
      try {
        await _firebaseAuth.currentUser!.delete();
      } on FirebaseAuthException catch (e) {
        throw FirebaseAuthException(code: e.code, message: e.message);
      } catch (e) {
        rethrow;
      }
    }
  }

  Future<void> logOut() async {
    try {
      await _facebookAuth.logOut();
      await _googleSignIn.signOut();
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.message);
    } catch (e) {
      log(e.toString());

      throw HttpException(e.toString());
    }
  }
}
