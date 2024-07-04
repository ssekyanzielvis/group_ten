import 'package:flutter/material.dart';

class FoodCard extends StatelessWidget {
  final String categoryName;
  final String imagePath;
  final String numberOfItems;

  FoodCard(
      {required this.categoryName,
      required this.imagePath,
      required this.numberOfItems});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 20.0),
      child: Card(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
          child: Row(
            children: <Widget>[
              Image(
                image: AssetImage(imagePath),
                height: 50.0,
                width: 50.0,
              ),
              SizedBox(width: 30.0),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      categoryName,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "$numberOfItems Kinds",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
