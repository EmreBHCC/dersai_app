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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyBinKs8sF71WxlC7KZIf6V_e1kSR8K5fA8',
    appId: '1:879511121813:web:2000ca70cf9fe014d2109c',
    messagingSenderId: '879511121813',
    projectId: 'dersai-app-fb995',
    authDomain: 'dersai-app-fb995.firebaseapp.com',
    storageBucket: 'dersai-app-fb995.firebasestorage.app',
    measurementId: 'G-ZSE3Z1V3B7',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCxtw7FEqrx79S-NDpyCR2qIk7n_3Di9fI',
    appId: '1:879511121813:android:9203ffac05806b48d2109c',
    messagingSenderId: '879511121813',
    projectId: 'dersai-app-fb995',
    storageBucket: 'dersai-app-fb995.firebasestorage.app',
  );

}