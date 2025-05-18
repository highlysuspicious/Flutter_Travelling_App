import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'; // Needed if you add the platform logic

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {

    return android;
  }


  // Firebase Options specifically for your Android application (com.rabbil.app1)
  static const FirebaseOptions android = FirebaseOptions(
    // YOUR_API_KEY needs to be filled in from your generated firebase_options.dart
    // This key is specific to your project and Android app.
    apiKey: 'AIzaSyCp9T9zTxNKXz0577KlN7_3rl8xEwiAP48',
    // YOUR_APP_ID needs to be filled in from your generated firebase_options.dart
    // This is the Google App ID for your Android app, format is typically 1:ProjectNumber:android:Hash
    appId: '1:893899111681:android:59fa21c0ef5578d418af00',
    messagingSenderId: '893899111681', // Your Firebase Project Number
    projectId: 'app1-ec8a5', // Your Firebase Project ID
    // storageBucket is often ProjectID.firebasestorage.app
    storageBucket: 'app1-ec8a5.firebasestorage.app',
    // authDomain is often ProjectID.firebaseapp.com
    authDomain: 'app1-ec8a5.firebaseapp.com', // Needed for some auth flows like web/redirect
    // Other config values like databaseURL, measurementId, etc. would go here if needed and applicable to Android
  );
}
