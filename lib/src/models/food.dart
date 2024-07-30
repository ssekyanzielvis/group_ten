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
      pricePerKg: (data['pricePerKg'] ?? 0).toDouble(),
      imageUrl: data['imageUrl'] ?? '',
      price: (data['price'] is int
          ? (data['price'] as int).toDouble()
          : (data['price'] as double? ?? 0.0)),
      restaurantName: data['restaurantName'] ?? '',
      restaurantPhoneNumber: data['restaurantPhoneNumber'] ?? '',
    );
  }

  factory Food.fromFirestore(Map<String, dynamic> data) {
    return Food(
      id: data['id'],
      name: data['name'] ?? '',
      values: data['values'] ?? '',
      bestTimeToEat: data['bestTimeToEat'] ?? '',
      pricePerKg: (data['pricePerKg'] ?? 0).toDouble(),
      imageUrl: data['imageUrl'] ?? '',
      price: (data['price'] is int
          ? (data['price'] as int).toDouble()
          : (data['price'] as double? ?? 0.0)),
      restaurantName: data['restaurantName'] ?? '',
      restaurantPhoneNumber: data['restaurantPhoneNumber'] ?? '',
    );
  }
}
