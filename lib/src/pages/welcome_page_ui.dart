import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import '../models/choice.dart';
//import '../models/order_confirmation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/login_screen.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  String? _selectedMealType;
  final _budgetController = TextEditingController();
  String? _selectedPaymentMethod;
  String _deliveryAddress =
      "Your current location"; // Placeholder for user location

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to Food Dash'),
        actions: [
          GestureDetector(
            onTap: () async {
              try {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              } catch (e) {
                print('Error signing out: $e');
                // Show an error message or handle error appropriately
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.logout),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose your meal:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ListTile(
              title: const Text('Breakfast'),
              leading: Radio<String>(
                value: 'Breakfast',
                groupValue: _selectedMealType,
                onChanged: (String? value) {
                  setState(() {
                    _selectedMealType = value;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Lunch'),
              leading: Radio<String>(
                value: 'Lunch',
                groupValue: _selectedMealType,
                onChanged: (String? value) {
                  setState(() {
                    _selectedMealType = value;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Dinner'),
              leading: Radio<String>(
                value: 'Dinner',
                groupValue: _selectedMealType,
                onChanged: (String? value) {
                  setState(() {
                    _selectedMealType = value;
                  });
                },
              ),
            ),
            TextField(
              controller: _budgetController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Enter your budget'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _showAvailableFoods,
              child: Text('Show Available Foods'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAvailableFoods() {
    final budget = double.tryParse(_budgetController.text) ?? 0.0;
    if (_selectedMealType == null || budget <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Please select a meal type and enter a valid budget')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AvailableFoodsPage(
          mealType: _selectedMealType!,
          budget: budget,
          onOrderConfirmed: _handleOrderConfirmation,
        ),
      ),
    );
  }

  void _handleOrderConfirmation(Order order) {
    FirebaseFirestore.instance
        .collection('orders')
        .add(order.toMap())
        .then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Order placed successfully!')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to place order: $error')),
      );
    });
  }
}

class AvailableFoodsPage extends StatelessWidget {
  final String mealType;
  final double budget;
  final Function(Order) onOrderConfirmed;

  AvailableFoodsPage({
    required this.mealType,
    required this.budget,
    required this.onOrderConfirmed,
  });

  @override
  Widget build(BuildContext context) {
    // Simulating available foods and restaurants based on budget
    final availableFoods = [
      {'name': 'Food 1', 'restaurant': 'Restaurant A'},
      {'name': 'Food 2', 'restaurant': 'Restaurant B'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Available Foods'),
      ),
      body: ListView.builder(
        itemCount: availableFoods.length,
        itemBuilder: (context, index) {
          final food = availableFoods[index];
          return ListTile(
            title: Text(food['name']!),
            subtitle: Text('Restaurant: ${food['restaurant']}'),
            onTap: () {
              _showPaymentDialog(context, food['restaurant']!);
            },
          );
        },
      ),
    );
  }

  void _showPaymentDialog(BuildContext context, String restaurant) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Payment Method'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Cash'),
                leading: Radio<String>(
                  value: 'Cash',
                  groupValue: _selectedPaymentMethod,
                  onChanged: (String? value) {
                    _selectedPaymentMethod = value;
                    Navigator.pop(context);
                    _confirmOrder(context, restaurant);
                  },
                ),
              ),
              ListTile(
                title: const Text('Mobile Money'),
                leading: Radio<String>(
                  value: 'Mobile Money',
                  groupValue: _selectedPaymentMethod,
                  onChanged: (String? value) {
                    _selectedPaymentMethod = value;
                    Navigator.pop(context);
                    _confirmOrder(context, restaurant);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _confirmOrder(BuildContext context, String restaurant) {
    final order = Order(
      mealType: mealType,
      budget: budget,
      paymentMethod: _selectedPaymentMethod!,
      restaurant: restaurant,
      deliveryAddress: 'Current Location', // Placeholder for user's location
    );
    onOrderConfirmed(order);
  }

  String? _selectedPaymentMethod;
}

class Order {
  final String mealType;
  final double budget;
  final String paymentMethod;
  final String restaurant;
  final String deliveryAddress;

  Order({
    required this.mealType,
    required this.budget,
    required this.paymentMethod,
    required this.restaurant,
    required this.deliveryAddress,
  });

  Map<String, dynamic> toMap() {
    return {
      'mealType': mealType,
      'budget': budget,
      'paymentMethod': paymentMethod,
      'restaurant': restaurant,
      'deliveryAddress': deliveryAddress,
    };
  }

  static Order fromMap(Map<String, dynamic> map) {
    return Order(
      mealType: map['mealType'],
      budget: map['budget'],
      paymentMethod: map['paymentMethod'],
      restaurant: map['restaurant'],
      deliveryAddress: map['deliveryAddress'],
    );
  }
}
