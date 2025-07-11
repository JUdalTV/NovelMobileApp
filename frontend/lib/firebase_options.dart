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
    apiKey: 'AIzaSyCgs9R2DN5wJos_zK2VsnhAzU_7RfP4Kx4',
    appId: '1:143851977304:web:6b8e800aef45bd3237282d',
    messagingSenderId: '143851977304',
    projectId: 'tu-tien-novel',
    authDomain: 'tu-tien-novel.firebaseapp.com',
    storageBucket: 'tu-tien-novel.firebasestorage.app',
    measurementId: 'G-LWEC4QEBCK',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCNfddUTn7hUqeDicVpiOiITFKqy4X0_Gc',
    appId: '1:143851977304:android:47dbd3573177df7c37282d',
    messagingSenderId: '143851977304',
    projectId: 'tu-tien-novel',
    storageBucket: 'tu-tien-novel.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC2e61Hm02N75d0scrlh4R__6sqyAV5VC8',
    appId: '1:143851977304:ios:5f4fcaabda95b25037282d',
    messagingSenderId: '143851977304',
    projectId: 'tu-tien-novel',
    storageBucket: 'tu-tien-novel.firebasestorage.app',
    iosBundleId: 'com.example.frontend',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC2e61Hm02N75d0scrlh4R__6sqyAV5VC8',
    appId: '1:143851977304:ios:5f4fcaabda95b25037282d',
    messagingSenderId: '143851977304',
    projectId: 'tu-tien-novel',
    storageBucket: 'tu-tien-novel.firebasestorage.app',
    iosBundleId: 'com.example.frontend',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCgs9R2DN5wJos_zK2VsnhAzU_7RfP4Kx4',
    appId: '1:143851977304:web:986d866d7b55e50b37282d',
    messagingSenderId: '143851977304',
    projectId: 'tu-tien-novel',
    authDomain: 'tu-tien-novel.firebaseapp.com',
    storageBucket: 'tu-tien-novel.firebasestorage.app',
    measurementId: 'G-SDWVW24VQ5',
  );

}