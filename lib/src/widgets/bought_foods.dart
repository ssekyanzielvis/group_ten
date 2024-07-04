import 'package:flutter/material.dart';

class BoughtFoods extends StatefulWidget {
  const BoughtFoods({super.key});

  @override
  State<BoughtFoods> createState() => _BoughtFoodsState();
}

class _BoughtFoodsState extends State<BoughtFoods> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: 200.0,
          width: 340.0,
          child: Image.asset(
            "lib/assets/images/all favourites ice cream.jfif",
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          left: 0.0,
          bottom: 0.0,
          child: Container(
            height: 60.0,
            width: 340.0,
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: [
                Colors.black,
                Colors.black12,
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            )),
          ),
        ),
      ],
    );
  }
}
