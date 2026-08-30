// File generated for Firebase Initialization
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
          'DefaultFirebaseOptions have not been configured for linux.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBlKcet_etdVdTiY6Y15lv7grOKfUvl778',
    appId: '1:1074569113150:android:a661bfcdaaa41e7a366b6f',
    messagingSenderId: '1074569113150',
    projectId: 'smart-cb',
    authDomain: 'smart-cb.firebaseapp.com',
    storageBucket: 'smart-cb.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBlKcet_etdVdTiY6Y15lv7grOKfUvl778',
    appId: '1:1074569113150:android:a661bfcdaaa41e7a366b6f',
    messagingSenderId: '1074569113150',
    projectId: 'smart-cb',
    storageBucket: 'smart-cb.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBlKcet_etdVdTiY6Y15lv7grOKfUvl778',
    appId: '1:1074569113150:android:a661bfcdaaa41e7a366b6f',
    messagingSenderId: '1074569113150',
    projectId: 'smart-cb',
    storageBucket: 'smart-cb.firebasestorage.app',
    iosBundleId: 'com.example.smartCb',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBlKcet_etdVdTiY6Y15lv7grOKfUvl778',
    appId: '1:1074569113150:android:a661bfcdaaa41e7a366b6f',
    messagingSenderId: '1074569113150',
    projectId: 'smart-cb',
    storageBucket: 'smart-cb.firebasestorage.app',
    iosBundleId: 'com.example.smartCb',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBlKcet_etdVdTiY6Y15lv7grOKfUvl778',
    appId: '1:1074569113150:android:a661bfcdaaa41e7a366b6f',
    messagingSenderId: '1074569113150',
    projectId: 'smart-cb',
    authDomain: 'smart-cb.firebaseapp.com',
    storageBucket: 'smart-cb.firebasestorage.app',
  );
}
