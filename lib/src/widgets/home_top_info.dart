import 'package:flutter/material.dart';

class HomeTopInfo extends StatelessWidget {
  final textStyle = TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold);
  HomeTopInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}
