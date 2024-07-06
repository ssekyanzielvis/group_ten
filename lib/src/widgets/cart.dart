import 'package:flutter/material.dart';
import '../models/cart_item.dart'; // Import your CartItem model

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<CartItem> cartItems = [];

  void addItem(CartItem item) {
    setState(() {
      cartItems.add(item);
    });
  }

  void removeItem(int index) {
    setState(() {
      cartItems.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          final item = cartItems[index];
          return Dismissible(
            key: UniqueKey(),
            onDismissed: (direction) {
              removeItem(index);
            },
            background: Container(color: Colors.red),
            child: ListTile(
              leading: Image.asset(item.imagePath, height: 50, width: 50),
              title: Text(item.categoryName),
              subtitle: Text('Quantity: ${item.quantity}'),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  removeItem(index);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
