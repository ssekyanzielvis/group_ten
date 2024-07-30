// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'bugdet.dart';
import '../screens/login_screen.dart';
import '../pages/register_restaurant_page.dart';
// import your MessagesPage

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final _budgetController = TextEditingController();
  int newMessageCount = 0;

  @override
  void initState() {
    super.initState();
    _listenForMessages();
  }

  @override
  void dispose() {
    _budgetController.dispose();
    super.dispose();
  }

  void _listenForMessages() {
    FirebaseFirestore.instance
        .collection('messages')
        .where('isRead', isEqualTo: false)
        .snapshots()
        .listen((snapshot) {
      setState(() {
        newMessageCount = snapshot.docs.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final String todayDate = DateFormat.yMMMMd().format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Welcome to Food Dash',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shadowColor: Colors.black,
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const RegisterRestaurantPage()),
              );
            },
            child: const Text('Register Restaurant',
                style: TextStyle(fontSize: 12)),
          ),
          GestureDetector(
            onTap: () async {
              try {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              } catch (e) {
                if (kDebugMode) {
                  print('Error signing out: $e');
                }
              }
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.logout,
                color: Colors.white,
              ),
            ),
          ),
        ],
        backgroundColor: Colors.deepOrange,
        centerTitle: true,
        elevation: 10,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.fastfood,
              size: 100,
              color: Colors.deepOrange,
            ),
            const SizedBox(height: 20),
            const Text(
              'Tell us your budget for today by tapping here:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Date: $todayDate',
              style: const TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BudgetScreen()),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 5,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: const Text(
                  'Tap to Enter Budget',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                shadowColor: Colors.black,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MessagesPage()),
                );
              },
              child: Text(
                'View Messages from restaurants ($newMessageCount new)',
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
