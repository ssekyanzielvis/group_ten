import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final textStyle = TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.only(top: 40, left: 20, right: 20),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('What are you gonna Eat?', style: textStyle),
                  Text('Choose your favorite food', style: textStyle),
                ],
              ),
              Icon(Icons.notifications_none,
                  size: 30.0, color: Theme.of(context).primaryColor),
            ],
          ),
        ],
      ),
    );
  }
}
