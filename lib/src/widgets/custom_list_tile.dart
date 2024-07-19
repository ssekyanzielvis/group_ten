import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final IconData icon;
  final String text;

  CustomListTile({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: <Widget>[
          Card(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(icon, color: Colors.blue),
                      SizedBox(width: 10),
                      Text(text),
                    ],
                  ),
                  Divider(
                    height: 10,
                    color: Colors.grey,
                    indent: 20.0,
                  ),
                  Row(
                    children: <Widget>[
                      Icon(icon, color: Colors.blue),
                      SizedBox(width: 10),
                      Text(text),
                    ],
                  ),
                  Divider(
                    height: 10,
                    color: Colors.grey,
                    indent: 20.0,
                  ),
                  Row(
                    children: <Widget>[
                      Icon(icon, color: Colors.blue),
                      SizedBox(width: 10),
                      Text(text),
                    ],
                  ),
                  Divider(
                    height: 10,
                    color: Colors.grey,
                    indent: 20.0,
                  ),
                  Row(
                    children: <Widget>[
                      Icon(icon, color: Colors.blue),
                      SizedBox(width: 10),
                      Text(text),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
