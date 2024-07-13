import 'package:cloud_firestore/cloud_firestore.dart';

class Restaurant {
  String rid;
  String name;

  Restaurant({
    required this.rid,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'rid': rid,
      'name': name,
    };
  }

  factory Restaurant.fromMap(DocumentSnapshot<Map<String, dynamic>> document) {
    return Restaurant(
      rid: document.data()!['rid'] ?? '',
      name: document.data()!['name'] ?? '',
    );
  }

  toJson() {
    return {
      'rid': rid,
      'name': name,
    };
  }
}
