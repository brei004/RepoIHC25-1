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
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyAIYZuoNsgiyDCL4Hkx9L_7kE4LUrFkk7g',
    appId: '1:217022951498:web:508eef71b7c69ccb8876b3',
    messagingSenderId: '217022951498',
    projectId: 'pluma-ai-71f24',
    authDomain: 'pluma-ai-71f24.firebaseapp.com',
    storageBucket: 'pluma-ai-71f24.firebasestorage.app',
    measurementId: 'G-7FMWK2VB01',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCqURUdeAetAlMvtLZDkQpSt0uz3w832lY',
    appId: '1:217022951498:android:c05d151ddc3c10408876b3',
    messagingSenderId: '217022951498',
    projectId: 'pluma-ai-71f24',
    storageBucket: 'pluma-ai-71f24.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDaZa2X3tvCa9Pj2UqU6wCeNS2zep6UDdg',
    appId: '1:217022951498:ios:7357fdc6db560a668876b3',
    messagingSenderId: '217022951498',
    projectId: 'pluma-ai-71f24',
    storageBucket: 'pluma-ai-71f24.firebasestorage.app',
    iosBundleId: 'com.example.plumaAi',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDaZa2X3tvCa9Pj2UqU6wCeNS2zep6UDdg',
    appId: '1:217022951498:ios:7357fdc6db560a668876b3',
    messagingSenderId: '217022951498',
    projectId: 'pluma-ai-71f24',
    storageBucket: 'pluma-ai-71f24.firebasestorage.app',
    iosBundleId: 'com.example.plumaAi',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAIYZuoNsgiyDCL4Hkx9L_7kE4LUrFkk7g',
    appId: '1:217022951498:web:aa846afa19cbc15c8876b3',
    messagingSenderId: '217022951498',
    projectId: 'pluma-ai-71f24',
    authDomain: 'pluma-ai-71f24.firebaseapp.com',
    storageBucket: 'pluma-ai-71f24.firebasestorage.app',
    measurementId: 'G-9PEFQ495SY',
  );
}
