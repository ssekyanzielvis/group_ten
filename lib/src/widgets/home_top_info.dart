import 'package:flutter/material.dart';

class HomeTopInfo extends StatelessWidget {
  final textStyle = TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold);
  HomeTopInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('You are most welcome', style: textStyle),
              Text('Fellow foodie', style: textStyle),
            ],
          ),
          Row(
            children: [
              Icon(
                Icons.notifications_none,
                size: 30.0,
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(
                  width: 10.0), // Add some space between the icon and the image
              Padding(
                padding:
                    const EdgeInsets.only(top: 5.0), // Add padding if necessary
                child: Image.asset(
                  'lib/assets/images/food collection.jpg', // Replace with your image path
                  height: 20.0, // Define the height of the image
                  width: 20.0, // Define the width of the image
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
