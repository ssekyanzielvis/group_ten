import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
//import '../pages/register_restaurant_page.dart';
import 'bugdet.dart';
//import '../widgets/auth_service.dart';
//import '../pages/calculator.dart';
//import 'package:food_dash/src/pages/food_provider.dart';
//import '../pages/profile_page.dart';
//import '../pages/help.dart';
import '../models/food.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/login_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<QueryDocumentSnapshot> searchResults = [];
  /*int newMessageCount = 0;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  int currentTabIndex = 0;
  late List<Widget> pages;
  late Widget currentPage;
 
  late Widget homePage;
  late BlogScreen blogScreen;
  late HelpPage helpPage;
  late ProfilePage profilePage;

  @override
  void initState() {
    super.initState();

    // Initialize pages
    homePage = const HomePage();
    blogScreen = const BlogScreen();
    helpPage = const HelpPage();
    profilePage = const ProfilePage();
    pages = [
      homePage,
      blogScreen,
      helpPage,
      profilePage
    ]; // Correctly assign the pages
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
  }*/

  void _searchFoods(String query) async {
    try {
      final result = await _firestore
          .collection('foods')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: '$query\uf8ff')
          .get();

      setState(() {
        searchResults = result.docs;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error searching foods: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: const Text('Deliver Your Best Foods With Fooddash'),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () async {
              try {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  // ignore: use_build_context_synchronously
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
      ),
      /*drawer: Drawer(
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
            _createDrawerItem(
                icon: Icons.home,
                text: 'Home',
                onTap: () {
                  setState(() {
                    currentTabIndex = 0;
                    currentPage = pages[0];
                  });
                  Navigator.pop(context);
                }),
            _createDrawerItem(
                icon: Icons.book,
                text: 'Blog',
                onTap: () {
                  setState(() {
                    currentTabIndex = 1;
                    currentPage = pages[1];
                  });
                  Navigator.pop(context);
                }),
            _createDrawerItem(
                icon: Icons.help,
                text: 'Help',
                onTap: () {
                  setState(() {
                    currentTabIndex = 2;
                    currentPage = pages[2];
                  });
                  Navigator.pop(context);
                }),
            _createDrawerItem(
                icon: Icons.person,
                text: 'Profile',
                onTap: () {
                  setState(() {
                    currentTabIndex = 3;
                    currentPage = pages[3];
                  });
                  Navigator.pop(context);
                }),
            _createDrawerItem(
                icon: Icons.message_sharp,
                text: 'Messages',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MessagesPage()),
                  );
                }),
            _createDrawerItem(
                icon: Icons.app_registration_rounded,
                text: 'Register Restaurant',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RegisterRestaurantPage()),
                  );
                }),
            _createDrawerItem(
                icon: Icons.calculate_rounded,
                text: 'Calculator',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CalculatorScreen(),
                    ),
                  );
                }),
          ],
        ),
      ),*/
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: _firestore.collection('foods').snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No foods available'));
                  }

                  final foodItems = snapshot.data!.docs;

                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                    ),
                    itemCount: foodItems.length,
                    itemBuilder: (context, index) {
                      var foodItem = foodItems[index];
                      return GestureDetector(
                        onTap: () => _navigateToFoodDetailPage(
                            context, foodItem['name']),
                        child: Card(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              foodItem.data() is Map<String, dynamic> &&
                                      (foodItem.data() as Map<String, dynamic>)
                                          .containsKey('imageUrl') &&
                                      foodItem['imageUrl'] != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          8.0), // Rounded corners
                                      child: SizedBox(
                                        height: 420, // Set the desired height
                                        width: double
                                            .infinity, // Make the image fill the width of the parent
                                        child: Image.network(
                                          foodItem['imageUrl'],
                                          height:
                                              420, // Match the height of the container
                                          width: double
                                              .infinity, // Match the width of the container
                                          fit: BoxFit
                                              .cover, // Make the image cover the entire container
                                          errorBuilder: (BuildContext context,
                                              Object exception,
                                              StackTrace? stackTrace) {
                                            return Container(
                                              height:
                                                  420, // Match the height of the container
                                              width: double
                                                  .infinity, // Match the width of the container
                                              color: Colors.grey,
                                              child: const Icon(
                                                Icons.error,
                                                color: Colors.white,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    )
                                  : Container(
                                      height:
                                          420, // Set the same height as the image container
                                      width: double
                                          .infinity, // Make the placeholder fill the width of the parent
                                      color: Colors.grey,
                                      child: const Icon(
                                        Icons.fastfood,
                                        color: Colors.white,
                                      ),
                                    ),
                              const SizedBox(height: 8.0),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal:
                                        8.0), // Add some horizontal padding
                                child: Container(
                                  color: Colors
                                      .white, // Optional: Set a background color for the text container
                                  child: Text(
                                    foodItem['name'],
                                    style: const TextStyle(fontSize: 18.0),
                                    textAlign: TextAlign
                                        .center, // Center the text within the container
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            if (searchResults.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: searchResults.length,
                  itemBuilder: (context, index) {
                    var foodItem = searchResults[index];
                    return ListTile(
                      title: Text(foodItem['name']),
                      subtitle: Text('Price: ${foodItem['price']}'),
                      leading: foodItem.data() != null &&
                              (foodItem.data() as Map<String, dynamic>)
                                  .containsKey('imageUrl') &&
                              foodItem['imageUrl'] != null
                          ? Image.network(foodItem['imageUrl'])
                          : null,
                      onTap: () => _navigateToPaymentScreen(context, foodItem),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const Icon(Icons.search),
              const SizedBox(width: 8.0),
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search your favourite food!',
                    border: InputBorder.none,
                  ),
                  onSubmitted: (value) {
                    _searchFoods(value);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToFoodDetailPage(BuildContext context, String foodName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FoodDetailPage(foodName: foodName),
      ),
    );
  }

  void _navigateToPaymentScreen(
      BuildContext context, QueryDocumentSnapshot foodSnapshot) {
    Food food = Food.fromDocument(foodSnapshot);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentScreen(food: food),
      ),
    );
  }
}

class FoodDetailPage extends StatelessWidget {
  final String foodName;

  const FoodDetailPage({super.key, required this.foodName});

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    return Scaffold(
      appBar: AppBar(
        title: Text('$foodName Details'),
      ),
      body: StreamBuilder(
        stream: firestore
            .collection('foods')
            .where('name', isEqualTo: foodName)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
                child: Text('No details available for this food'));
          }

          final foodItems = snapshot.data!.docs;

          return ListView.builder(
            itemCount: foodItems.length,
            itemBuilder: (context, index) {
              var foodItem = foodItems[index];
              return GestureDetector(
                onTap: () => _navigateToPaymentScreen(context, foodItem),
                child: Card(
                  child: ListTile(
                    leading: foodItem.data() != null &&
                            (foodItem.data() as Map<String, dynamic>)
                                .containsKey('imageUrl') &&
                            foodItem['imageUrl'] != null &&
                            foodItem['imageUrl'] is String
                        ? Image.network(
                            foodItem['imageUrl'],
                            height: 50,
                            width: 50,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            height: 50,
                            width: 50,
                            color: Colors.grey,
                            child: const Icon(
                              Icons.fastfood,
                              color: Colors.white,
                            ),
                          ),
                    title:
                        foodItem['name'] != null && foodItem['name'] is String
                            ? Text(foodItem['name'])
                            : const Text('Unknown food name'),
                    subtitle:
                        foodItem['price'] != null && foodItem['price'] is int
                            ? Text('Price: ${foodItem['price']}')
                            : const Text('Price not available'),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _navigateToPaymentScreen(
      BuildContext context, QueryDocumentSnapshot foodSnapshot) {
    Food food = Food.fromDocument(foodSnapshot);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentScreen(food: food),
      ),
    );
  }
}

class PaymentScreen extends StatelessWidget {
  final Food food;
  PaymentScreen({super.key, required this.food});

  final AirtelPaymentService _paymentService = AirtelPaymentService();

  void _processCashPayment(BuildContext context, Food food) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LocationScreen(
          name: food.name, // Use the actual food name
          restaurantName: food.restaurantName, // Use the actual restaurant name
        ),
      ),
    );
  }

  void _processMobilePayment(BuildContext context, bool isCashIn) async {
    if (isCashIn) {
      await _paymentService.cashIn(food.price.toString() as double,
          food.restaurantPhoneNumber as String);
    } else {
      await _paymentService.cashOut(food.price.toString() as double,
          food.restaurantPhoneNumber as String);
    }

    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${isCashIn ? 'Cash In' : 'Cash Out'} processed')),
    );

    Navigator.push(
      // ignore: use_build_context_synchronously
      context,
      MaterialPageRoute(
        builder: (context) => PaymentConfirmationScreen(food: food),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Payment for ${food.name}',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.deepOrange,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Choose payment method for ${food.name}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _processCashPayment(context, food),
              style: ElevatedButton.styleFrom(
                iconColor: Colors.green,
                disabledIconColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.money),
                  SizedBox(width: 10),
                  Text('Pay by Cash'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _processMobilePayment(context, true),
              style: ElevatedButton.styleFrom(
                disabledIconColor: Colors.blue,
                iconColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.phone_android),
                  SizedBox(width: 10),
                  Text('Cash In with Mobile Money'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _processMobilePayment(context, false),
              style: ElevatedButton.styleFrom(
                disabledIconColor: Colors.blue,
                iconColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.phone_android),
                  SizedBox(width: 10),
                  Text('Cash Out with Mobile Money'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
