import 'package:flutter/material.dart';

class OrderConfirmationScreen extends StatelessWidget {
  final String mealType;
  final double budget;
  final String restaurant;
  final String dietRecommendation;

  const OrderConfirmationScreen({super.key, 
    required this.mealType,
    required this.budget,
    required this.restaurant,
    required this.dietRecommendation,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Confirmation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Meal Type: $mealType',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Budget: \$$budget',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Restaurant: $restaurant',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Diet Recommendation: $dietRecommendation',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SingleChildScrollView(
              child: Flexible(
                child: SizedBox(
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
                    child: const Text('Confirm Order'),
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
