class UserChoice {
  final String mealType;
  final double budget;

  UserChoice({required this.mealType, required this.budget});

  Map<String, dynamic> toMap() {
    return {
      'mealType': mealType,
      'budget': budget,
    };
  }

  static UserChoice fromMap(Map<String, dynamic> map) {
    return UserChoice(
      mealType: map['mealType'],
      budget: map['budget'],
    );
  }
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
