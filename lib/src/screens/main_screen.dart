import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:food_dash/src/pages/food_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../pages/profile_page.dart';
import '../widgets/auth_service.dart';
import '../pages/register_restaurant_page.dart';
import '../pages/bugdet.dart';
import '../pages/calculator.dart';
import '../pages/help.dart';
import '../pages/home.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  int newMessageCount = 0;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  int currentTabIndex = 0;

  late List<Widget> pages;
  late Widget currentPage;

  late HomePage homePage;
  late BlogScreen blogScreen;
  late HelpPage helpPage;
  late ProfilePage profilePage;

  @override
  void initState() {
    super.initState();

    // Initialize pages
    homePage = const HomePage();
    blogScreen = const BlogScreen(); // Initialize BlogScreen
    helpPage = const HelpPage();
    profilePage = const ProfilePage();
    pages = [homePage, blogScreen, helpPage, profilePage];
    currentPage = pages[0];

    // Initialize Firebase Messaging
    _firebaseMessaging.requestPermission();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('Received a message while in the foreground!');
        print('Message data: ${message.data}');
      }
      if (message.notification != null) {
        if (kDebugMode) {
          print(
              'Message also contained a notification: ${message.notification}');
        }
        _showNotification(
            message.notification!.title!, message.notification!.body!);
      }
    });
    _initializeNotifications();
    _listenForMessages();
  }

  void _initializeNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void _showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('channel_id', 'channel_name',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: false);
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'item x',
    );
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Dash'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await AuthService().signOut();
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.deepOrange,
              ),
              child: Text(
                'Food Dash',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                setState(() {
                  currentTabIndex = 0;
                  currentPage = pages[0];
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text('Blog'),
              onTap: () {
                setState(() {
                  currentTabIndex = 1;
                  currentPage = pages[1];
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('Help'),
              onTap: () {
                setState(() {
                  currentTabIndex = 2;
                  currentPage = pages[2];
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                setState(() {
                  currentTabIndex = 3;
                  currentPage = pages[3];
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.message_sharp),
              title: const Text('Messages'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MessagesPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.app_registration_rounded),
              title: const Text('Register Restaurant'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const RegisterRestaurantPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.calculate_rounded),
              title: const Text('Calculator'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CalculatorScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: currentPage,
    );
  }
}
