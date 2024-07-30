import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:food_dash/src/pages/home.dart';
import 'screens/main_screen.dart';
import 'screens/login_screen.dart';
import 'widgets/auth_service.dart';
import 'screens/signup_screen.dart';
//import 'pages/bugdet.dart';

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
      initialRoute: '/',
      routes: {
        '/': (context) => const WidgetTree(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const MainScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/forgot_password': (context) => const ForgotPasswordScreen(),
        // Add other routes as needed
      },
    );
  }
}

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _WidgetTreeState createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;
          return Navigator(
            onGenerateRoute: (settings) {
              if (user == null) {
                return MaterialPageRoute(
                    builder: (context) => const LoginScreen());
              } else {
                return MaterialPageRoute(
                    builder: (context) => const MainScreen());
              }
            },
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}


/*import 'package:flutter/material.dart';
import 'screens/main_screen.dart';
// Import your home page widget here

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'food Dash',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainScreen(), // Set your home page widget here
    );
  }
}
*/