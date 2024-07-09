import 'package:flutter/material.dart';
//import 'home_screen.dart';
//import 'screens/main_screen.dart';
//import 'widgets/responsive.dart';
import 'screens/cart_screen.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'widgets/layout.dart';
import 'package:food_dash/authentication page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    Firebase.initializeApp();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "FOOD DASH",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: Responsive(
      // mobile: MainScreen(),
      // tablet: MainScreen(),
      // desktop: MainScreen(),
      // ),
      routes: {
        '/': (context) => AuthScreen(),
        //'/menu': (context) => MenuScreen(),
        '/cart': (context) => CartScreen(
              cartItems: [],
            ),
        //'/profile': (context) => ProfileScreen(),
        //'/order-history': (context) => OrderHistoryScreen(),
      },
    );
  }
}
