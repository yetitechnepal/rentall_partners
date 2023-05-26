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
    apiKey: 'AIzaSyDy_GqUEon9SVA4pV5OlIAz6H2nj73Zj_I',
    appId: '1:77506248560:android:96bc8c25889225af4bd9b5',
    messagingSenderId: '77506248560',
    projectId: 'equipment-rental-app',
    storageBucket: 'equipment-rental-app.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDW3GjqWz0YngkNh1ZQXrjQEiyLrVe0lPc',
    appId: '1:77506248560:ios:a7264a415fdf3cc24bd9b5',
    messagingSenderId: '77506248560',
    projectId: 'equipment-rental-app',
    storageBucket: 'equipment-rental-app.appspot.com',
    androidClientId: '77506248560-05477eqen51mjudm01v232b3fpi53qiv.apps.googleusercontent.com',
    iosClientId: '77506248560-p0onjshthqp8cv46l6iaeopch1qm0737.apps.googleusercontent.com',
    iosBundleId: 'com.rental.partners',
  );
}
