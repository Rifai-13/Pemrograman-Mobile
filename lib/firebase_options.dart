// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
      return web;
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAQaJPUHLgqfxHN4s0cJ9jQBNm5tAusJOs',
    appId: '1:557191222204:web:77dbf1e9bd61ec67d0d1b9',
    messagingSenderId: '557191222204',
    projectId: 'modul3-b0ccb',
    authDomain: 'modul3-b0ccb.firebaseapp.com',
    storageBucket: 'modul3-b0ccb.appspot.com',
    measurementId: 'G-0NVP7YYDCD',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCVM6JtXn8y6YTkahpTGi95h-2gatebhrw',
    appId: '1:557191222204:android:acf154bce51c7bb9d0d1b9',
    messagingSenderId: '557191222204',
    projectId: 'modul3-b0ccb',
    storageBucket: 'modul3-b0ccb.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAH2GEyZkK-alntsYtwPOLSZihJ79KbFoQ',
    appId: '1:557191222204:ios:56162ae658a2183fd0d1b9',
    messagingSenderId: '557191222204',
    projectId: 'modul3-b0ccb',
    storageBucket: 'modul3-b0ccb.appspot.com',
    iosBundleId: 'com.example.modul3',
  );
}
