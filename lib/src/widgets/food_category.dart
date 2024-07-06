import 'package:flutter/material.dart';
import '../data/category_data.dart';
//import '../models/category_model.dart';
import 'food_card.dart';
import '../models/cart_item.dart'; // Import the CartItem model

class FoodCategory extends StatelessWidget {
  final List<Category> _categories = categories;
  final Function(CartItem) onAddToCart;

  FoodCategory({required this.onAddToCart});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (BuildContext context, int index) {
          return FoodCard(
            categoryName: _categories[index].categoryName,
            imagePath: _categories[index].imagePath,
            numberOfItems: _categories[index].numberOfItems.toString(),
            onAddToCart: onAddToCart,
          );
        },
      ),
    );
  }
}
