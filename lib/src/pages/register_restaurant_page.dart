import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../models/restaurant_model.dart';
import '../pages/bugdet.dart';

class RegisterRestaurantPage extends StatefulWidget {
  const RegisterRestaurantPage({super.key});

  @override
  _RegisterRestaurantPageState createState() => _RegisterRestaurantPageState();
}

class _RegisterRestaurantPageState extends State<RegisterRestaurantPage> {
  final restaurantRepo = Get.put(RestaurantRepository());
  final _formKey = GlobalKey<FormState>();
  late String _restaurantName, _password;
  bool _isLogin = false;

  void _toggleFormType() {
    setState(() {
      _isLogin = !_isLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLogin ? 'Login Restaurant' : 'Register Restaurant'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orangeAccent, Colors.deepOrange],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Restaurant Name',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(Icons.restaurant),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a restaurant name';
                        }
                        return null;
                      },
                      onSaved: (value) => _restaurantName = value!,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(Icons.lock),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.length < 8) {
                          return 'Please enter a password with at least 8 characters';
                        }
                        return null;
                      },
                      onSaved: (value) => _password = value!,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          if (_isLogin) {
                            _loginRestaurant();
                          } else {
                            _registerRestaurant();
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 15),
                        iconColor: Colors.deepOrange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(_isLogin ? 'Login' : 'Register'),
                    ),
                    TextButton(
                      onPressed: _toggleFormType,
                      child: Text(_isLogin
                          ? 'Don\'t have an account? Register'
                          : 'Already have an account? Login'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> createRestaurant(Restaurant restaurant) async {
    await restaurantRepo.createRestaurant(restaurant);
  }

  void _registerRestaurant() async {
    try {
      final docRef =
          await FirebaseFirestore.instance.collection('restaurants').add({
        'name': _restaurantName,
        'password': _password,
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => RestaurantHomePage(
            restaurantId: docRef.id,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration failed: $e')),
      );
    }
  }

  void _loginRestaurant() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('restaurants')
          .where('name', isEqualTo: _restaurantName)
          .where('password', isEqualTo: _password)
          .get();

      if (snapshot.docs.isNotEmpty) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => RestaurantHomePage(
              restaurantId: snapshot.docs.first.id,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid restaurant name or password')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: $e')),
      );
    }
  }
}

class RestaurantHomePage extends StatefulWidget {
  final String restaurantId;

  const RestaurantHomePage({super.key, required this.restaurantId});

  @override
  _RestaurantHomePageState createState() => _RestaurantHomePageState();
}

class _RestaurantHomePageState extends State<RestaurantHomePage> {
  final _formKey = GlobalKey<FormState>();
  late String _foodName, _price;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant Home Page'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NotificationScreen()),
                );
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.deepOrange,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.notifications, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'View Notifications',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Food Name',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a food name';
                      }
                      return null;
                    },
                    onSaved: (value) => _foodName = value!,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Price',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a price';
                      }
                      return null;
                    },
                    onSaved: (value) => _price = value!,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        // Save food to Firestore
                        FirebaseFirestore.instance
                            .collection('restaurants')
                            .doc(widget.restaurantId)
                            .collection('foods')
                            .add({
                          'name': _foodName,
                          'price': _price,
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 15,
                      ),
                      iconColor: Colors.deepOrange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Add Food'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('restaurants')
                    .doc(widget.restaurantId)
                    .collection('foods')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot food = snapshot.data!.docs[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                food['name'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'UGX ${food['price']}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.deepOrange,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//import 'dart:nativewrappers/_internal/vm/lib/core_patch.dart';

class RestaurantRepository extends GetxController {
  static RestaurantRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  createRestaurant(Restaurant restaurant) async {
    try {
      await _db
          .collection('restaurants')
          .doc(restaurant.rid)
          .set(restaurant.toJson())
          .whenComplete(
            () => Get.snackbar(
              "Success",
              "Mission Success",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green.withOpacity(0.1),
              colorText: Colors.blue,
            ),
          );
    } catch (error) {
      Get.snackbar(
        "Error",
        "Something Wrong happened. Please try again",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.blue,
      );
      print(error.toString());
    }
  }
}
