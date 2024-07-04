import 'package:flutter/material.dart';

class FoodCard extends StatelessWidget {
  const FoodCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: <Widget>[
          Image(
            image: AssetImage("assets/images/burger.png"),
            height: 65.0,
            width: 65.0,
          ),
          Column(children: <Widget>[
            Text(
              "Burger",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              "5 Kinds",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ])
        ],
      ),
    );
  }
}
