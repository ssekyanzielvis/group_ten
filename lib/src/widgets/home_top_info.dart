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
              Text('Fellow Foodie', style: textStyle),
            ],
          ),
          Icon(Icons.handshake,
              size: 40.0, color: Theme.of(context).primaryColor),
        ],
      ),
    );
  }
}
