import 'package:flutter/material.dart';

class BoughtFoods extends StatefulWidget {
  final String id;
  final String name;
  final String imagePath;
  final String category;
  final double price;
  final double discount;
  final double ratings;

  BoughtFoods({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.category,
    required this.price,
    required this.discount,
    required this.ratings,
  });

  @override
  State<BoughtFoods> createState() => _BoughtFoodsState();
}

class _BoughtFoodsState extends State<BoughtFoods> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Stack(
        children: <Widget>[
          Container(
            height: 200.0,
            width: 340.0,
            child: Image.asset(
              widget.imagePath,
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
          Positioned(
            left: 10.0,
            bottom: 10.0,
            right: 10.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.star,
                          color: Colors.red,
                          size: 18,
                        ),
                        Icon(
                          Icons.star,
                          color: Colors.red,
                          size: 18,
                        ),
                        Icon(
                          Icons.star,
                          color: Colors.red,
                          size: 18,
                        ),
                        Icon(
                          Icons.star,
                          color: Colors.red,
                          size: 18,
                        ),
                        Icon(
                          Icons.star,
                          color: Colors.red,
                          size: 18,
                        ),
                        SizedBox(width: 2.0),
                        Text(
                          "(" + widget.ratings.toString() + " Reviews)",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text(
                      widget.price.toString(),
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Full Package.",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
