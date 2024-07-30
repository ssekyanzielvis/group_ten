import 'package:flutter/material.dart';
import '../widgets/order_card.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your Food Cart',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 92, 62, 201),
        elevation: 0.0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        scrollDirection: Axis.vertical,
        children: const <Widget>[
          OrderCard(
            foodItem: 'chips',
            description: 'Taste the feeling.',
            price: 10.0,
            imageUrl: 'lib/assets/images/chips chicken salads.jfif',
            status: 'Delivered',
          ),
        ],
      ),
    );
  }
}
