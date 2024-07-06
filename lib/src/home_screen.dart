import 'package:flutter/material.dart';
import 'package:food_dash/src/widgets/food_category.dart';
import 'package:food_dash/src/widgets/home_top_info.dart';
import 'package:food_dash/src/widgets/search_field.dart';
import 'package:food_dash/src/widgets/bought_foods.dart';
import 'package:food_dash/src/data/food_data.dart';
import 'package:food_dash/src/models/background.dart';
import 'package:food_dash/src/models/food_model.dart';
import 'package:food_dash/src/models/cart_item.dart';
//import '../src/widgets/cart.dart';
import '../src/screens/cart_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Food> _foods = foods; // Ensure foods is defined and imported
  List<CartItem> _cartItems = [];

  void _addToCart(CartItem item) {
    setState(() {
      _cartItems.add(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HEY! FOODIE'),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CartScreen(cartItems: _cartItems),
                ),
              );
            },
          ),
        ],
      ),
      body: Background(
        child: ListView(
          padding: EdgeInsets.only(top: 40, left: 20, right: 20),
          children: <Widget>[
            HomeTopInfo(),
            FoodCategory(onAddToCart: _addToCart),
            SizedBox(height: 20),
            SearchField(),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Frequently Bought Foods.",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    "View All",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            Column(
              children: _foods.map(_buildFoodItems).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodItems(Food food) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.0),
      child: BoughtFoods(
        id: food.id,
        name: food.name,
        imagePath: food.imagePath,
        category: food.category,
        discount: food.discount,
        price: food.price,
        ratings: food.ratings,
      ),
    );
  }
}
