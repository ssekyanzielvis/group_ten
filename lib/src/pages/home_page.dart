import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../screens/login_screen.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

@override
class _HomePageState extends State<HomePage> {
  String selectedMeal = '';
  double budget = 0.0;
  String dietRecommendation = 'Eat balanced meals!';
  List<dynamic> nearbyRestaurants = [];

  final TextEditingController _budgetController = TextEditingController();

  void _setMealType(String meal) {
    setState(() {
      selectedMeal = meal;
    });
  }

  void _submitBudget() {
    setState(() {
      budget = double.tryParse(_budgetController.text) ?? 0.0;
    });
  }

  Future<void> _findNearbyRestaurants() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      final url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
          '?location=${position.latitude},${position.longitude}'
          '&radius=1500'
          '&type=restaurant'
          '&key=9189-0514-2451';

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          nearbyRestaurants = json.decode(response.body)['results'];
        });
      } else {
        print('Failed to load nearby restaurants');
      }
    } catch (e) {
      print('Error fetching location: $e');
    }
  }

  void _makeOrder() {
    if (selectedMeal.isEmpty || budget <= 0 || nearbyRestaurants.isEmpty) {
      // Display an alert if any required input is missing
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text(
              'Please select a meal type, enter a budget, and find nearby restaurants.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    // Navigate to order confirmation screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderConfirmationScreen(
          mealType: selectedMeal,
          budget: budget,
          restaurant: nearbyRestaurants.first['name'],
          dietRecommendation: dietRecommendation,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome To Food Dash',
            style: TextStyle(
                color: Colors.blue, fontSize: 30, fontWeight: FontWeight.bold)),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choose a meal type:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () => _setMealType('Breakfast'),
                    child: Text('Breakfast'),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _setMealType('Lunch'),
                    child: Text('Lunch'),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _setMealType('Dinner'),
                    child: Text('Dinner'),
                  ),
                  SizedBox(height: 16),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Enter your budget:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: _budgetController,
                decoration: InputDecoration(labelText: 'Budget'),
                keyboardType: TextInputType.number,
              ),
              ElevatedButton(
                onPressed: () {
                  _submitBudget();
                  _findNearbyRestaurants();
                },
                child: Text('Submit Budget'),
              ),
              SizedBox(height: 20),
              Text(
                'Diet Recommendation:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                dietRecommendation,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              nearbyRestaurants.isEmpty
                  ? Text('No nearby restaurants found.')
                  : Expanded(
                      child: ListView.builder(
                        itemCount: nearbyRestaurants.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(nearbyRestaurants[index]['name']),
                            subtitle:
                                Text(nearbyRestaurants[index]['vicinity']),
                          );
                        },
                      ),
                    ),
              ElevatedButton(
                onPressed: _makeOrder,
                child: Text('Order Now'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OrderConfirmationScreen extends StatelessWidget {
  final String mealType;
  final double budget;
  final String restaurant;
  final String dietRecommendation;

  OrderConfirmationScreen({
    required this.mealType,
    required this.budget,
    required this.restaurant,
    required this.dietRecommendation,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Confirmation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Meal Type: $mealType',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Budget: \$$budget',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Restaurant: $restaurant',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Diet Recommendation: $dietRecommendation',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            SingleChildScrollView(
              child: Flexible(
                child: Container(
                  height: 30,
                  child: ElevatedButton(
                    onPressed: () {
                      // Replace these variables with your actual captured values
                      String mealType = 'Lunch'; // Example meal type
                      String restaurant =
                          'Local Restaurant'; // Example restaurant
                      double budget = 20.0; // Example budget

                      // Implement final order logic here
                      print(
                          'Order confirmed for $mealType at $restaurant within budget of \$$budget');

                      // Navigate back to home screen
                      Navigator.pop(
                          context); // Close the current screen and return to the previous screen
                    },
                    child: Text('Confirm Order'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
