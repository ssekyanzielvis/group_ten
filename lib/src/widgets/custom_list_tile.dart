import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final IconData icon;
  final String text;

  const CustomListTile({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: <Widget>[
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(icon, color: Colors.blue),
                      const SizedBox(width: 10),
                      Text(text),
                    ],
                  ),
                  const Divider(
                    height: 10,
                    color: Colors.grey,
                    indent: 20.0,
                  ),
                  Row(
                    children: <Widget>[
                      Icon(icon, color: Colors.blue),
                      const SizedBox(width: 10),
                      Text(text),
                    ],
                  ),
                  const Divider(
                    height: 10,
                    color: Colors.grey,
                    indent: 20.0,
                  ),
                  Row(
                    children: <Widget>[
                      Icon(icon, color: Colors.blue),
                      const SizedBox(width: 10),
                      Text(text),
                    ],
                  ),
                  const Divider(
                    height: 10,
                    color: Colors.grey,
                    indent: 20.0,
                  ),
                  Row(
                    children: <Widget>[
                      Icon(icon, color: Colors.blue),
                      const SizedBox(width: 10),
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
