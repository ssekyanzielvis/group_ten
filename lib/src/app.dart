import 'package:flutter/material.dart';
//import 'home_screen.dart';
import 'screens/main_screen.dart';
import 'widgets/responsive.dart';
//import 'widgets/layout.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "FOOD DASH",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Responsive(
        mobile: MainScreen(),
        tablet: MainScreen(),
        desktop: MainScreen(),
      ),
    );
  }
}
