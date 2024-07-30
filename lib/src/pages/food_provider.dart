// ignore_for_file: library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/food.dart';

class BlogScreen extends StatelessWidget {
  const BlogScreen({super.key});

  Future<List<Food>> fetchFoods() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('foods').get();
      return snapshot.docs
          .map((doc) => Food.fromFirestore(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching foods: $e');
      }
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Food Blog',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.deepOrange,
      ),
      body: FutureBuilder<List<Food>>(
        future: fetchFoods(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            if (kDebugMode) {
              print('Error in FutureBuilder: ${snapshot.error}');
            }
            return const Center(child: Text('An error occurred!'));
          } else {
            final foods = snapshot.data ?? [];
            return GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 2 / 2.5,
              ),
              itemCount: foods.length,
              itemBuilder: (ctx, index) {
                final food = foods[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: food.imageUrl,
                          placeholder: (ctx, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (ctx, url, error) =>
                              const Icon(Icons.error),
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        food.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Best time to eat: ${food.bestTimeToEat}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'Values: ${food.values}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'UGX ${food.pricePerKg.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.green,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const Spacer(),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange,
                        ),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (ctx) => FoodDetailScreen(
                              foodId: food.id,
                              foodItems: const [],
                            ),
                          ));
                        },
                        child: const Text('View Details'),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrange,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (ctx) => const AddFoodScreen()),
          );
        },
      ),
    );
  }
}

class AddFoodScreen extends StatefulWidget {
  const AddFoodScreen({super.key});

  @override
  _AddFoodScreenState createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _values = '';
  String _bestTimeToEat = '';
  double _pricePerKg = 0.0;
  String _imageUrl = '';
  final double _restaurantPhoneNumber = 0.0;

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newFood = Food(
        id: DateTime.now().toString(),
        name: _name,
        values: _values,
        bestTimeToEat: _bestTimeToEat,
        pricePerKg: _pricePerKg,
        imageUrl: _imageUrl,
        price:
            _pricePerKg, // Assuming price is same as pricePerKg for simplicity
        restaurantName: '', // Add default or input values if needed
        //
        restaurantPhoneNumber:
            _restaurantPhoneNumber, // Add default or input values if needed
      );
      await _db.collection('foods').add({
        'name': newFood.name,
        'values': newFood.values,
        'bestTimeToEat': newFood.bestTimeToEat,
        'pricePerKg': newFood.pricePerKg,
        'imageUrl': newFood.imageUrl,
        'price': newFood.price,
        'restaurantName': newFood.restaurantName,
        'restaurantPhoneNumber': newFood.restaurantPhoneNumber,
      });
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Food',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.deepOrange,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box_rounded),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                textInputAction: TextInputAction.next,
                onSaved: (value) {
                  _name = value!;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Values',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                textInputAction: TextInputAction.next,
                onSaved: (value) {
                  _values = value!;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Best Time to Eat',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                textInputAction: TextInputAction.next,
                onSaved: (value) {
                  _bestTimeToEat = value!;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Price @',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  _pricePerKg = double.parse(value!);
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Image URL',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                keyboardType: TextInputType.url,
                onSaved: (value) {
                  _imageUrl = value!;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveForm,
                style: ElevatedButton.styleFrom(
                  iconColor: Colors.green,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FoodDetailScreen extends StatelessWidget {
  final String foodId;

  const FoodDetailScreen(
      {super.key, required this.foodId, required List<dynamic> foodItems});

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore db = FirebaseFirestore.instance;
    final opinionController = TextEditingController();

    void addOpinion(String foodId) async {
      if (opinionController.text.isNotEmpty) {
        await db.collection('foods').doc(foodId).collection('opinions').add({
          'opinion': opinionController.text,
        });
        opinionController.clear();
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Opinion added!')),
        );
      }
    }

    return FutureBuilder<DocumentSnapshot>(
      future: db.collection('foods').doc(foodId).get(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.error != null) {
          return const Center(child: Text('An error occurred!'));
        } else if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Center(child: Text('Food not found!'));
        } else {
          final food =
              Food.fromFirestore(snapshot.data!.data() as Map<String, dynamic>);

          return Scaffold(
            appBar: AppBar(
              title: Text(
                food.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: Colors.deepOrange,
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CachedNetworkImage(
                    imageUrl: food.imageUrl,
                    placeholder: (ctx, url) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (ctx, url, error) => const Icon(Icons.error),
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Values: ${food.values}',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Best time to eat: ${food.bestTimeToEat}',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Price @: UGX${food.pricePerKg.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: opinionController,
                          decoration: InputDecoration(
                            labelText: 'Add your opinion',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            filled: true,
                            fillColor: Colors.grey[200],
                          ),
                          maxLines: 3,
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () => addOpinion(food.id),
                          style: ElevatedButton.styleFrom(
                            iconColor: Colors.green,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 15,
                            ),
                            textStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text('Submit Opinion'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
