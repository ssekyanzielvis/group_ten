import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:food_dash/src/pages/food_provider.dart';
import 'package:food_dash/src/pages/welcome_page_ui.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../pages/favourite_page.dart';
import '../pages/profile_page.dart';
import '../widgets/auth_service.dart';

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

  late WelcomePage homePage;
  // ignore: non_constant_identifier_names
  late BlogScreen
      // ignore: non_constant_identifier_names
      FoodDetailScreen; // Change variable name from orderPage to blogPage
  late FavoritesPage favouritePage;
  late ProfilePage profilePage;

  @override
  void initState() {
    super.initState();

    // Initialize pages
    homePage = const WelcomePage();
    FoodDetailScreen = const BlogScreen(); // Initialize BlogScreen
    favouritePage = const FavoritesPage();
    profilePage = const ProfilePage();
    pages = [homePage, FoodDetailScreen, favouritePage, profilePage];
    currentPage = pages[0];

    // Initialize Firebase Messaging
    _firebaseMessaging.requestPermission();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('Received a message while in the foreground!');
      }
      if (kDebugMode) {
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
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int index) {
          setState(() {
            currentTabIndex = index;
            currentPage = pages[index];
          });
        },
        currentIndex: currentTabIndex,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Blog',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.help),
            label: 'Help',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
      body: currentPage,
    );
  }
}
