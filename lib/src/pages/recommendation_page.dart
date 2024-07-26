import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Dash',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Map<String, dynamic>> foodItems = [
    {'name': 'Pizza', 'category': 'Fast Food', 'mealTime': 'Dinner', 'popularity': 4.5},
    {'name': 'Burger', 'category': 'Fast Food', 'mealTime': 'Lunch', 'popularity': 4.2},
    {'name': 'Salad', 'category': 'Healthy', 'mealTime': 'Lunch', 'popularity': 4.8},
    {'name': 'Sushi', 'category': 'Japanese', 'mealTime': 'Dinner', 'popularity': 4.6},
    {'name': 'Pasta', 'category': 'Italian', 'mealTime': 'Dinner', 'popularity': 4.3},
    {'name': 'Curry', 'category': 'Indian', 'mealTime': 'Lunch', 'popularity': 4.7},
  ];

  String recommendation = '';

  void recommendFood(String mealTime) {
    final recommendations = foodItems.where((item) => item['mealTime'] == mealTime).toList();
    if (recommendations.isNotEmpty) {
      recommendations.sort((a, b) => b['popularity'].compareTo(a['popularity']));
      setState(() {
        recommendation = recommendations.first['name'];
      });
    } else {
      setState(() {
        recommendation = 'No recommendations available for this meal time';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Dash'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Get a recommendation for your  meal:',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => recommendFood('Breakfast'),
              child: const Text('Breakfast'),
            ),
            ElevatedButton(
              onPressed: () => recommendFood('Lunch'),
              child: const Text('Lunch'),
            ),
            ElevatedButton(
              onPressed: () => recommendFood('Dinner'),
              child: const Text('Dinner'),
            ),
            const SizedBox(height: 20),
            Text(
              'Recommended Food: $recommendation',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
