import 'package:flutter/material.dart';
import 'package:food_dash/src/app.dart';

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
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

  runApp(App());

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    if (kReleaseMode) exit(1);
  };
}

//void main() {
//  runApp(App());
//}
