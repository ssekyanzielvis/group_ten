import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/login_screen.dart';
import '../pages/register_restaurant_page.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  String? _selectedMealType;
  final _budgetController = TextEditingController();

  @override
  void dispose() {
    _budgetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              backgroundColor: Colors.blue, // background color
              foregroundColor: Colors.white, // text color
              shadowColor: Colors.black, // shadow color
              elevation: 5, // elevation
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // rounded corners
              ),
              padding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 5), // padding
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const RegisterRestaurantPage()),
              );
            },
            child: const Text('Register Restaurant',
                style: TextStyle(fontSize: 12)), // text style
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
                print('Error signing out: $e');
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Choose your meal:',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange,
                ),
              ),
              const SizedBox(height: 10),
              _buildMealTypeOption('Breakfast'),
              const SizedBox(height: 5),
              _buildMealTypeOption('Lunch'),
              const SizedBox(height: 5),
              _buildMealTypeOption('Dinner'),
              const SizedBox(height: 20),
              _buildBudgetField(),
              const SizedBox(height: 20),
              _buildShowFoodsButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMealTypeOption(String mealType) {
    return ListTile(
      title: Text(
        mealType,
        style: const TextStyle(
          fontSize: 18,
          color: Colors.black,
        ),
      ),
      leading: Radio<String>(
        value: mealType,
        groupValue: _selectedMealType,
        onChanged: (String? value) {
          setState(() {
            _selectedMealType = value;
          });
        },
      ),
      contentPadding: const EdgeInsets.all(10),
      tileColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: Colors.deepOrange, width: 1),
      ),
    );
  }

  Widget _buildBudgetField() {
    return TextField(
      controller: _budgetController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Enter your budget',
        labelStyle: const TextStyle(
          fontSize: 18,
          color: Colors.grey,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.deepOrange,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.deepOrange,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildShowFoodsButton() {
    return Center(
      child: ElevatedButton(
        onPressed: _showAvailableFoods,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepOrange,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text(
          'Show Available Foods',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _showAvailableFoods() {
    final budget = double.tryParse(_budgetController.text) ?? 0.0;
    if (_selectedMealType == null || budget <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a meal type and enter a valid budget'),
        ),
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
        const SnackBar(content: Text('Order placed successfully!')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to place order: $error')),
      );
    });
  }
}

class Order {
  final String foodName;
  final String restaurant;
  final String paymentMethod;

  Order({
    required this.foodName,
    required this.restaurant,
    required this.paymentMethod,
  });

  Map<String, dynamic> toMap() {
    return {
      'foodName': foodName,
      'restaurant': restaurant,
      'paymentMethod': paymentMethod,
    };
  }
}

class AvailableFoodsPage extends StatefulWidget {
  final String mealType;
  final double budget;
  final Function(Order) onOrderConfirmed;

  const AvailableFoodsPage({
    super.key,
    required this.mealType,
    required this.budget,
    required this.onOrderConfirmed,
  });

  @override
  _AvailableFoodsPageState createState() => _AvailableFoodsPageState();
}

class _AvailableFoodsPageState extends State<AvailableFoodsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> availableFoods = [];
  List<Map<String, dynamic>> availableRestaurants = [];
  String? _selectedPaymentMethod;

  @override
  void initState() {
    super.initState();
    fetchFoodsAndRestaurants();
  }

  void _showPaymentDialog(
      BuildContext context, String foodName, String restaurant) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Payment Method'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                value: 'Credit Card',
                groupValue: _selectedPaymentMethod,
                onChanged: (value) {
                  setState(() {
                    _selectedPaymentMethod = value;
                  });
                },
                title: const Text('Credit Card'),
              ),
              RadioListTile<String>(
                value: 'Cash',
                groupValue: _selectedPaymentMethod,
                onChanged: (value) {
                  setState(() {
                    _selectedPaymentMethod = value;
                  });
                },
                title: const Text('Cash'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (_selectedPaymentMethod != null) {
                  final order = Order(
                    foodName: foodName,
                    restaurant: restaurant,
                    paymentMethod: _selectedPaymentMethod!,
                  );
                  widget.onOrderConfirmed(order);
                  Navigator.pop(context);
                }
              },
              child: const Text('Confirm'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Future<void> fetchFoodsAndRestaurants() async {
    try {
      final foodsSnapshot = await _firestore
          .collection('foods')
          .where('mealType', isEqualTo: widget.mealType)
          .where('price', isLessThanOrEqualTo: widget.budget)
          .get();
      final restaurantsSnapshot =
          await _firestore.collection('restaurants').get();

      final foods = foodsSnapshot.docs.map((doc) {
        return {
          'name': doc['name'],
          'restaurant': doc['restaurant'],
          'price': doc['price'],
        };
      }).toList();

      final restaurants = restaurantsSnapshot.docs.map((doc) {
        return {
          'name': doc['name'],
          'budget': doc['budget'],
        };
      }).toList();

      if (mounted) {
        setState(() {
          availableFoods = foods;
          availableRestaurants = restaurants;
        });
      }
    } catch (e) {
      print("Error fetching foods and restaurants: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Foods'),
      ),
      body: ListView.builder(
        itemCount: availableFoods.length,
        itemBuilder: (context, index) {
          final food = availableFoods[index];
          return ListTile(
            title: Text(food['name']),
            subtitle: Text('Restaurant: ${food['restaurant']}'),
            onTap: () {
              _showPaymentDialog(context, food['name'], food['restaurant']);
            },
          );
        },
      ),
    );
  }
}
