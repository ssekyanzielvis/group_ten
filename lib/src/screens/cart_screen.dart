import 'package:flutter/material.dart';
import '../models/cart_item.dart';

class CartScreen extends StatelessWidget {
  final List<CartItem> cartItems;

  const CartScreen({super.key, required this.cartItems});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          final item = cartItems[index];
          return ListTile(
            title: Text(item.categoryName),
            subtitle: Text('Price: ${item.price}'),
            trailing: Text('Quantity: ${item.quantity}'),
          );
        },
      ),
    );
  }
}
