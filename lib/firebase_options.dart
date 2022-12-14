// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC3D8XNDC6grOLJjBUsL1K32ini7RewpMM',
    appId: '1:90349006730:android:d74ba7eb3e947a09f22273',
    messagingSenderId: '90349006730',
    projectId: 'basita-app',
    databaseURL: 'https://basita-app-default-rtdb.firebaseio.com',
    storageBucket: 'basita-app.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAERo41-3cvA-2le41oSpIqqfbsGr6wQuE',
    appId: '1:90349006730:ios:842445aae1762555f22273',
    messagingSenderId: '90349006730',
    projectId: 'basita-app',
    databaseURL: 'https://basita-app-default-rtdb.firebaseio.com',
    storageBucket: 'basita-app.appspot.com',
    androidClientId: '90349006730-4d9fe0524jstlsa9r4287850najkuepq.apps.googleusercontent.com',
    iosClientId: '90349006730-b5i6e4eo5oinvgrc67i9akm3imq3sges.apps.googleusercontent.com',
    iosBundleId: 'com.scopelinks.basitaapp',
  );
}
