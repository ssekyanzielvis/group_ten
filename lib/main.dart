import 'package:flutter/material.dart';
import 'package:food_dash/src/app.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyDwsK44BBlWnncq9HF1U_e2LS98DOpRNoo",
            authDomain: "food-delivery-fc9ed.firebaseapp.com",
            projectId: "food-delivery-fc9ed",
            storageBucket: "food-delivery-fc9ed.appspot.com",
            messagingSenderId: "540760942496",
            appId: "1:540760942496:web:096ec50e21729531cfe6c5",
            measurementId: "G-W8QQNJBS1W"));
  }

  runApp(const App());

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    if (kReleaseMode) exit(1);
  };
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  if (kDebugMode) {
    print("Handling a background message: ${message.messageId}");
  }
}

//void main() {
//  runApp(App());
//}
