import 'package:cloud_firestore/cloud_firestore.dart';

class Food {
  final String id;
  final String name;
  final String values;
  final String bestTimeToEat;
  final double pricePerKg;
  final String imageUrl;
  final double price;
  final String restaurantName;
  final double restaurantPhoneNumber;

  Food({
    required this.id,
    required this.name,
    required this.values,
    required this.bestTimeToEat,
    required this.pricePerKg,
    required this.imageUrl,
    required this.price,
    required this.restaurantName,
    required this.restaurantPhoneNumber,
  });

  factory Food.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Food(
      id: doc.id,
      name: data['name'] ?? '',
      values: data['values'] ?? '',
      bestTimeToEat: data['bestTimeToEat'] ?? '',
      pricePerKg: (data['pricePerKg'] ?? 0.0).toDouble(),
      imageUrl: data['imageUrl'] ?? '',
      price: (data['price'] ?? 0.0).toDouble(),
      restaurantName: data['restaurantName'] ?? '',
      restaurantPhoneNumber: _convertToDouble(data['restaurantPhoneNumber']),
    );
  }

  static double _convertToDouble(dynamic value) {
    if (value is double) {
      return value;
    } else if (value is int) {
      return value.toDouble();
    } else if (value is String) {
      return double.tryParse(value) ?? 0.0;
    } else {
      return 0.0;
    }
  }

  factory Food.fromFirestore(Map<String, dynamic> data) {
    return Food(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      values: data['values'] ?? '',
      bestTimeToEat: data['bestTimeToEat'] ?? '',
      pricePerKg: (data['pricePerKg'] ?? 0.0).toDouble(),
      imageUrl: data['imageUrl'] ?? '',
      price: (data['price'] is int
          ? (data['price'] as int).toDouble()
          : (data['price'] as double? ?? 0.0)),
      restaurantName: data['restaurantName'] ?? '',
      restaurantPhoneNumber: _convertToDouble(data['restaurantPhoneNumber']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'values': values,
      'bestTimeToEat': bestTimeToEat,
      'pricePerKg': pricePerKg,
      'imageUrl': imageUrl,
      'price': price,
      'restaurantName': restaurantName,
      'restaurantPhoneNumber': restaurantPhoneNumber,
    };
  }
}

class FoodRepository {
  final CollectionReference _foodCollection;
  final FirebaseFirestore _firestore;

  FoodRepository()
      : _foodCollection = FirebaseFirestore.instance.collection('foods'),
        _firestore = FirebaseFirestore.instance;

  // Fetch all food items
  Future<List<Food>> getAllFoods() async {
    try {
      QuerySnapshot snapshot = await _foodCollection.get();
      return snapshot.docs.map((doc) => Food.fromDocument(doc)).toList();
    } catch (e) {
      throw Exception('Error fetching foods: $e');
    }
  }

  // Fetch a single food item by ID
  Future<Food> getFoodById(String id) async {
    try {
      DocumentSnapshot doc = await _foodCollection.doc(id).get();
      if (doc.exists) {
        return Food.fromDocument(doc);
      } else {
        throw Exception('Food not found');
      }
    } catch (e) {
      throw Exception('Error fetching food: $e');
    }
  }

  // Add a new food item
  Future<void> addFood(String restaurantId, Food food) async {
    try {
      await _firestore
          .collection('restaurants')
          .doc(restaurantId)
          .collection('foods')
          .add(food.toJson());
    } catch (e) {
      throw Exception('Error adding food: $e');
    }
  }

  // Update an existing food item
  Future<void> updateFood(Food food) async {
    try {
      await _foodCollection.doc(food.id).update(food.toJson());
    } catch (e) {
      throw Exception('Error updating food: $e');
    }
  }

  // Delete a food item
  Future<void> deleteFood(String id) async {
    try {
      await _foodCollection.doc(id).delete();
    } catch (e) {
      throw Exception('Error deleting food: $e');
    }
  }
}
