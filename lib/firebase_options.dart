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
    apiKey: 'AIzaSyAw5FlW-xvpPDaEqZK5O4WKfSWSOUCjtjE',
    appId: '1:963682646402:web:4d58062d599b312757379b',
    messagingSenderId: '963682646402',
    projectId: 'flutter-todo-a4f7e',
    authDomain: 'flutter-todo-a4f7e.firebaseapp.com',
    storageBucket: 'flutter-todo-a4f7e.appspot.com',
    measurementId: 'G-K69NQ0057H',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB8orUhJwNniShOUElDKNLHTu7PNVGeiaI',
    appId: '1:963682646402:android:13342b08d5c29c0057379b',
    messagingSenderId: '963682646402',
    projectId: 'flutter-todo-a4f7e',
    storageBucket: 'flutter-todo-a4f7e.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBInKLIot1j1R8kyUXmd8vgUq2Zmbi4xkQ',
    appId: '1:963682646402:ios:fc4a4704484c076b57379b',
    messagingSenderId: '963682646402',
    projectId: 'flutter-todo-a4f7e',
    storageBucket: 'flutter-todo-a4f7e.appspot.com',
    iosClientId: '963682646402-g2lapder9nhvn0tsj4vln2vnd92n0086.apps.googleusercontent.com',
    iosBundleId: 'com.personal.todos.todos',
  );
}