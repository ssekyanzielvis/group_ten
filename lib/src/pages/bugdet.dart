// ignore_for_file: use_build_context_synchronously, duplicate_ignore

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import '../pages/messages_reply.dart';
import 'calculator.dart';
// ignore: depend_on_referenced_packages
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/food.dart';

class BudgetScreen extends StatelessWidget {
  final TextEditingController _budgetController = TextEditingController();

  BudgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Enter Budget',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.deepOrange,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.deepOrange,
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    const FaIcon(
                      FontAwesomeIcons.coins, // New money icon
                      size: 50,
                      color: Colors.deepOrange,
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _budgetController,
                      decoration: InputDecoration(
                          labelText: 'Budget Amount',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.deepOrange,
                            ),
                          ),
                          prefixIcon: const Icon(Icons.payments)),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () {
                        final budget = double.tryParse(_budgetController.text);
                        if (budget != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  FoodListScreen(budget: budget),
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.search),
                      label: const Text('Submit'),
                      style: ElevatedButton.styleFrom(
                        iconColor: Colors.deepOrange,
                        disabledIconColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        textStyle: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CalculatorScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Tap to make Calculations',
                        style: TextStyle(
                          color: Colors.deepOrange,
                          decoration: TextDecoration.underline,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FoodListScreen extends StatelessWidget {
  final double budget;

  FoodListScreen({super.key, required this.budget});

  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Foods within Budget',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.deepOrange,
        centerTitle: true,
      ),
      body: FutureBuilder<List<Food>>(
        future: _firestoreService.getFoodsWithinBudget(budget),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No foods available within this budget.'),
            );
          } else {
            final foods = snapshot.data!;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Your food items displayed here
                    ...foods.map((food) {
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 10.0),
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.orange[50],
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: Colors.deepOrange,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              leading: const Icon(
                                Icons.fastfood,
                                color: Colors.deepOrange,
                                size: 40,
                              ),
                              title: Text(
                                food.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                'Price: ${food.price}, Restaurant: ${food.restaurantName}',
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        PaymentScreen(food: food),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Tap To Make Order',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),

                    // Button to navigate to RecentConsumptionScreen
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 20.0),
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RecentConsumptionScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 20.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                        child: const Text(
                          'View Recent Consumption',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

class AirtelPaymentService {
  final String authUrl = 'https://openapi.airtel.africa/auth/oauth2/token';
  final String apiUrl =
      'https://openapiuat.airtel.africa/standard/v2/cashin/'; // Cash in URL
  final String cashOutUrl =
      'https://openapiuat.airtel.africa/standard/v2/cashout/'; // Cash out URL
  final String apiKey = 'your_api_key'; // Replace with your actual API key
  final String apiSecret =
      'your_api_secret'; // Replace with your actual API secret
  // Replace with your actual API secret

  Future<String> getAccessToken() async {
    final response = await http.post(
      Uri.parse(authUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Basic ${base64Encode(utf8.encode('$apiKey:$apiSecret'))}',
      },
      body: jsonEncode({'grant_type': 'client_credentials'}),
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      return responseBody['access_token'];
    } else {
      throw Exception('Failed to get access token');
    }
  }

  Future<void> cashIn(double amount, String phoneNumber) async {
    final String accessToken = await getAccessToken();

    final Map<String, dynamic> requestBody = {
      'reference': 'your_reference',
      'subscriber': {
        'country': 'UG', // or your country code
        'currency': 'UGX', // or your currency code
        'msisdn': phoneNumber,
      },
      'transaction': {
        'amount': amount.toString(),
        'country': 'UG',
        'currency': 'UGX',
        'id': 'your_transaction_id',
      }
    };

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 201) {
      if (kDebugMode) {
        print('Cash In successful');
      }
    } else {
      if (kDebugMode) {
        print('Cash In failed: ${response.reasonPhrase}');
      }
    }
  }

  Future<void> cashOut(double amount, String phoneNumber) async {
    final String accessToken = await getAccessToken();

    final Map<String, dynamic> requestBody = {
      'reference': 'your_reference',
      'subscriber': {
        'country': 'UG', // or your country code
        'currency': 'UGX', // or your currency code
        'msisdn': phoneNumber,
      },
      'transaction': {
        'amount': amount.toString(),
        'country': 'UG',
        'currency': 'UGX',
        'id': 'your_transaction_id',
      }
    };

    final response = await http.post(
      Uri.parse(cashOutUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 201) {
      if (kDebugMode) {
        print('Cash Out successful');
      }
    } else {
      if (kDebugMode) {
        print('Cash Out failed: ${response.reasonPhrase}');
      }
    }
  }
}

class PaymentPage extends StatelessWidget {
  final Food food;
  PaymentPage({super.key, required this.food});

  final AirtelPaymentService _paymentService = AirtelPaymentService();

  void _processCashInPayment(
      BuildContext context, double amount, String phoneNumber) async {
    await _paymentService.cashIn(amount, phoneNumber);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cash In payment processed')),
    );
  }

  void _processCashOutPayment(
      BuildContext context, double amount, String phoneNumber) async {
    await _paymentService.cashOut(amount, phoneNumber);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cash Out payment processed')),
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
              onPressed: () => _processCashInPayment(context, food.price,
                  'user_phone_number'), // replace 'user_phone_number'
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
                  Text('Pay by Cash In'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _processCashOutPayment(context, food.price,
                  'user_phone_number'), // replace 'user_phone_number'
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
                  Text('Pay by Cash Out'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Food>> getFoodsWithinBudget(double budget) async {
    final querySnapshot = await _db
        .collection('foods')
        .where('price', isLessThanOrEqualTo: budget)
        .get();
    return querySnapshot.docs.map((doc) => Food.fromDocument(doc)).toList();
  }
}

/*class Food {
  final String name;
  final double price;
  final String imageUrl;
  final String restaurantName;
  final String restaurantPhoneNumber;

  Food(
      {required this.name,
      required this.price,
      required this.imageUrl,
      required this.restaurantName,
      required this.restaurantPhoneNumber});

  factory Food.fromFirestore(Map<String, dynamic> data) {
    return Food(
      name: data['name'],
      price: data['price'] ?? 0.0,
      imageUrl: data.containsKey('imageUrl') ? data['imageUrl'] ?? '' : '',
      restaurantName: data['restaurantName'],
      restaurantPhoneNumber: data['restaurantPhoneNumber'] ?? '',
    );
  }
}*/

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

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${isCashIn ? 'Cash In' : 'Cash Out'} processed')),
    );

    Navigator.push(
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

class PaymentConfirmationScreen extends StatelessWidget {
  final Food food;
  const PaymentConfirmationScreen({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Payment Confirmation',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepOrange,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.deepOrange,
                    width: 2,
                  ),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Icon(
                      Icons.check_circle_outline,
                      color: Colors.green,
                      size: 100,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Payment for ${food.name} has been processed successfully!',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.popUntil(context, (route) => route.isFirst);
                      },
                      icon: const Icon(Icons.home),
                      label: const Text('Back to Home'),
                      style: ElevatedButton.styleFrom(
                        iconColor: Colors.deepOrange,
                        disabledIconColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        textStyle: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LocationScreen extends StatelessWidget {
  final TextEditingController _locationController = TextEditingController();
  final String name;
  final String restaurantName;

  LocationScreen({super.key, required this.name, required this.restaurantName});

  void _confirmDelivery(BuildContext context) async {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final String location = _locationController.text;
      final String email = user.email!;
      final DateTime now = DateTime.now();

      await FirebaseFirestore.instance.collection('notifications').add({
        'location': location,
        'Food': name,
        'restaurantName': restaurantName,
        'email': email,
        'timestamp': now,
      });

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Food will be delivered in 5 minutes')),
      );

      // Navigate back or to the consumption screen
      // ignore: use_build_context_synchronously
      Navigator.popUntil(context, (route) => route.isFirst);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not logged in')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Your Location'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.orange[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: 'Location',
                  labelStyle: const TextStyle(color: Colors.deepOrange),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.deepOrange),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () => _confirmDelivery(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle),
                    SizedBox(width: 10),
                    Text('Confirm Delivery'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RecentConsumptionScreen extends StatelessWidget {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  RecentConsumptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Recent Food Consumption',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.deepOrange,
        centerTitle: true,
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: _db.collection('consumptions').get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No recent consumptions.'));
          } else {
            final consumptions = snapshot.data!.docs;
            return ListView.builder(
              itemCount: consumptions.length,
              itemBuilder: (context, index) {
                final data = consumptions[index].data() as Map<String, dynamic>;

                // Ensure 'food' field exists and is not null
                final food = data['name'] as String? ?? 'Unknown Food';

                // Ensure 'date' field exists and is not null
                final dynamic dateData = data['date'];
                DateTime date;

                // Handling different date formats
                if (dateData is Timestamp) {
                  date = dateData.toDate();
                } else if (dateData is int) {
                  date = DateTime.fromMillisecondsSinceEpoch(dateData);
                } else {
                  // Default to current date and time if format is unknown
                  date = DateTime.now();
                }

                return Card(
                  elevation: 3,
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Text(
                      food,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'Consumed on: ${date.toLocal()}',
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    leading: const Icon(
                      Icons.restaurant,
                      color: Colors.deepOrange,
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class NotificationScreen extends StatelessWidget {
  final String? notificationId;

  const NotificationScreen({super.key, this.notificationId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Colors.deepOrange,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('notifications').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No notifications available.'));
          } else {
            final notifications = snapshot.data!.docs;
            return ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final data =
                    notifications[index].data() as Map<String, dynamic>;
                final date = (data['timestamp'] as Timestamp).toDate();
                final String food = data['Food'] ?? 'Unknown Food';
                final String restaurantName =
                    data['restaurantName'] ?? 'Unknown Restaurant';
                final String location = data['location'] ?? 'Unknown Location';
                final String email = data['email'] ?? 'Unknown Email';

                return Card(
                  elevation: 3,
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Text(food),
                    subtitle: Text(
                      'Restaurant: $restaurantName\n'
                      'Customer Location: $location\n'
                      'Customer Email: $email\n'
                      'Ordered on: ${date.toLocal()}',
                    ),
                    leading: const Icon(
                      Icons.notifications,
                      color: Colors.deepOrange,
                    ),
                    trailing: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Tap to send message to customer.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(width: 5),
                        Icon(
                          Icons.message,
                          color: Colors.deepOrange,
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MessageScreen(
                            notificationId: notifications[index].id,
                            messageId: '',
                            message: '',
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class MessageScreen extends StatelessWidget {
  final String messageId;
  final String message;
  final DateTime? timestamp;
  final String notificationId;
  final TextEditingController _messageController = TextEditingController();

  // Unified constructor
  MessageScreen({
    super.key,
    required this.messageId,
    required this.message,
    this.timestamp,
    required this.notificationId,
  });

  void _sendMessage(BuildContext context) async {
    final String message = _messageController.text;

    if (message.isNotEmpty) {
      await FirebaseFirestore.instance.collection('messages').add({
        'notificationId': notificationId,
        'message': message,
        'Message ID': messageId,
        'timestamp': DateTime.now(),
      });

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Message sent')),
      );

      // Navigate back to the previous screen
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Message cannot be empty')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send a Message'),
        backgroundColor: Colors.deepOrange,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.orange[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: _messageController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: 'Type your message',
                    labelStyle: const TextStyle(color: Colors.deepOrange),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.deepOrange),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () => _sendMessage(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.send),
                      SizedBox(width: 10),
                      Text('Send Message'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MessageListScreen(),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.deepOrange,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Text(
                      'Tap To View Customer Replies',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});

  void _markAsRead(String messageId) async {
    await FirebaseFirestore.instance
        .collection('messages')
        .doc(messageId)
        .update({'isRead': true});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        backgroundColor: Colors.deepOrange,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('messages')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No messages available.'));
          } else {
            final messages = snapshot.data!.docs;
            return ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final Map<String, dynamic> data =
                    snapshot.data!.docs[index].data() as Map<String, dynamic>;
                final String notificationId =
                    data['notificationId'] as String? ??
                        'Unknown Notification ID';
                final messageDoc = messages[index];
                final date = (data['timestamp'] as Timestamp?)?.toDate();
                final message =
                    data['message'] as String? ?? 'No message content';
                final messageId = messages[index].id;

                return InkWell(
                  onTap: () async {
                    _markAsRead(messageId);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MessageInputScreen(
                          messageId: messageId,
                          message: message,
                          notificationId: notificationId,
                          timestamp: date,
                          inputMessageId: '',
                        ),
                      ),
                    );
                    // Mark the message as read
                    await FirebaseFirestore.instance
                        .collection('messages')
                        .doc(messageDoc.id)
                        .update({'isRead': true});

                    Navigator.push(
                      // ignore: use_build_context_synchronously
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MessageDetailPage(message: message),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 3,
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.orange[50],
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        title: Text(
                          message,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (date != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  'Sent on: ${date.toLocal()}',
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 14),
                                ),
                              ),
                            const SizedBox(height: 8),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                'Tap To Reply Message',
                                style: TextStyle(
                                  color: Colors.blue[600],
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        leading: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.deepOrange,
                          ),
                          child: const Icon(
                            Icons.message,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class MessageDetailPage extends StatelessWidget {
  final String message;

  const MessageDetailPage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Message Details'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // Additional message details can be displayed here
          ],
        ),
      ),
    );
  }
}
