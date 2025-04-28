import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

// Firebase-Konfiguration für verschiedene Plattformen
class FirebaseConfig {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    // Android
    return android;
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'YOUR_API_KEY',
    appId: 'YOUR_APP_ID',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    authDomain: 'YOUR_AUTH_DOMAIN',
    storageBucket: 'YOUR_STORAGE_BUCKET',
    measurementId: 'YOUR_MEASUREMENT_ID',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'YOUR_API_KEY',
    appId: 'YOUR_APP_ID',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    storageBucket: 'YOUR_STORAGE_BUCKET',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAsk6_LBBTOwQxYe9Mq1v2iE4if5L1xxWc',
    appId: '1:570594449302:ios:0dd18d7fdd72f972d36fb7',
    messagingSenderId: '570594449302',
    projectId: 'swustl-abaf1',
    storageBucket: 'swustl-abaf1.firebasestorage.app',
    iosClientId: '',
    iosBundleId: 'com.example.swustl',
  );

  // Initialisierung von Firebase
  static Future<void> init() async {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: currentPlatform,
      );
    }
  }
}