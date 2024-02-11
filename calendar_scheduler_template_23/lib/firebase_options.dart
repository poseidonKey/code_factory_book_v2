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
    apiKey: 'AIzaSyCd3lKIfP9F1HySbxRc0dkslep-c_jmvd4',
    appId: '1:380088802231:web:ef001a9efccf56164ce632',
    messagingSenderId: '380088802231',
    projectId: 'calendar-scheduler-eaf1d',
    authDomain: 'calendar-scheduler-eaf1d.firebaseapp.com',
    storageBucket: 'calendar-scheduler-eaf1d.appspot.com',
    measurementId: 'G-3H4PG5FPGT',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDcTFeHjsKxsRW_uc6GpqM6G3gxQ46kvjA',
    appId: '1:380088802231:android:8b43ad1b9408e7414ce632',
    messagingSenderId: '380088802231',
    projectId: 'calendar-scheduler-eaf1d',
    storageBucket: 'calendar-scheduler-eaf1d.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC8qPAutbqVt2Pu66kusbbC9bWDmQOhZpA',
    appId: '1:380088802231:ios:c6653745ada39f894ce632',
    messagingSenderId: '380088802231',
    projectId: 'calendar-scheduler-eaf1d',
    storageBucket: 'calendar-scheduler-eaf1d.appspot.com',
    androidClientId: '380088802231-0o8co4f2oa2c9n654pfich0kbs1obr1u.apps.googleusercontent.com',
    iosClientId: '380088802231-21kblqeot3o5sh7ojalisia3ml0uibgh.apps.googleusercontent.com',
    iosBundleId: 'com.example.calendarScheduler',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC8qPAutbqVt2Pu66kusbbC9bWDmQOhZpA',
    appId: '1:380088802231:ios:c37e3fcd1d1a104f4ce632',
    messagingSenderId: '380088802231',
    projectId: 'calendar-scheduler-eaf1d',
    storageBucket: 'calendar-scheduler-eaf1d.appspot.com',
    androidClientId: '380088802231-0o8co4f2oa2c9n654pfich0kbs1obr1u.apps.googleusercontent.com',
    iosClientId: '380088802231-gloqkdb5a43fikoot3aiuukv4jlbtu62.apps.googleusercontent.com',
    iosBundleId: 'com.example.calendarScheduler.RunnerTests',
  );
}
