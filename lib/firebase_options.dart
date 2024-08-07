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
    apiKey: 'AIzaSyDoSyaOfUVxPLKzbstQiVf4wxheIhjr5r0',
    appId: '1:1028484626304:web:ce62d274ee03435688f365',
    messagingSenderId: '1028484626304',
    projectId: 'alfaaluminiumworks',
    authDomain: 'alfaaluminiumworks.firebaseapp.com',
    storageBucket: 'alfaaluminiumworks.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCz6r_XiPySs3IyAZEDYvmiOIrMg9Z7vRo',
    appId: '1:1028484626304:android:e5088728391e56d788f365',
    messagingSenderId: '1028484626304',
    projectId: 'alfaaluminiumworks',
    storageBucket: 'alfaaluminiumworks.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB6NybMuv7MC-zL9o6mwoS-899IfuFaq9c',
    appId: '1:1028484626304:ios:1f4cf970cb8ab84f88f365',
    messagingSenderId: '1028484626304',
    projectId: 'alfaaluminiumworks',
    storageBucket: 'alfaaluminiumworks.appspot.com',
    iosBundleId: 'com.example.workerApplication',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB6NybMuv7MC-zL9o6mwoS-899IfuFaq9c',
    appId: '1:1028484626304:ios:1f4cf970cb8ab84f88f365',
    messagingSenderId: '1028484626304',
    projectId: 'alfaaluminiumworks',
    storageBucket: 'alfaaluminiumworks.appspot.com',
    iosBundleId: 'com.example.workerApplication',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDoSyaOfUVxPLKzbstQiVf4wxheIhjr5r0',
    appId: '1:1028484626304:web:69aeaf0f399d552b88f365',
    messagingSenderId: '1028484626304',
    projectId: 'alfaaluminiumworks',
    authDomain: 'alfaaluminiumworks.firebaseapp.com',
    storageBucket: 'alfaaluminiumworks.appspot.com',
  );
}
