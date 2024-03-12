// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyC0Kl5lWnh5AS5_nF38YXVt-1MeSAWiqI8',
    appId: '1:752135450715:web:97ac2aaccb819bca13cf7e',
    messagingSenderId: '752135450715',
    projectId: 'rec-ecommerce',
    authDomain: 'rec-ecommerce.firebaseapp.com',
    storageBucket: 'rec-ecommerce.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDM8PjW4A2dmoB2O4GrT0IPjN7x_rNyxt0',
    appId: '1:752135450715:android:bcf7a8f7961d3bdd13cf7e',
    messagingSenderId: '752135450715',
    projectId: 'rec-ecommerce',
    storageBucket: 'rec-ecommerce.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDI5k0_BVeeYH-zAtfRC9Y7ykObQ3vdhCU',
    appId: '1:752135450715:ios:b882379167db320f13cf7e',
    messagingSenderId: '752135450715',
    projectId: 'rec-ecommerce',
    storageBucket: 'rec-ecommerce.appspot.com',
    iosBundleId: 'com.example.recEcommerce',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDI5k0_BVeeYH-zAtfRC9Y7ykObQ3vdhCU',
    appId: '1:752135450715:ios:51a249261bde967c13cf7e',
    messagingSenderId: '752135450715',
    projectId: 'rec-ecommerce',
    storageBucket: 'rec-ecommerce.appspot.com',
    iosBundleId: 'com.example.recEcommerce.RunnerTests',
  );
}
