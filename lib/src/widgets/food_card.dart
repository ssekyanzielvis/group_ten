import 'package:flutter/material.dart';

import '../models/cart_item.dart'; // Import your CartScreen

class FoodCard extends StatelessWidget {
  final String categoryName;
  final String imagePath;
  final String numberOfItems;
  final Function(CartItem) onAddToCart;

  FoodCard({
    required this.categoryName,
    required this.imagePath,
    required this.numberOfItems,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 20.0),
      child: InkWell(
        onTap: () {
          // Add your onTap functionality here
        },
        child: Card(
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image(
                  image: AssetImage(imagePath),
                  height: 65.0,
                  width: 65.0,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 30.0),
                Flexible(
                  fit: FlexFit.loose,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        categoryName,
                        style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      Text(
                        "$numberOfItems Kinds",
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    onAddToCart(CartItem(
                      categoryName: categoryName,
                      imagePath: imagePath,
                      quantity: 1,
                      price: 34,
                    ));
                  },
                  icon: const Icon(
                    Icons.add_shopping_cart,
                    color: Colors.grey,
                    size: 30.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
