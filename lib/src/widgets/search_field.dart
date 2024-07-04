import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      child: TextField(
        decoration: InputDecoration(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 30, vertical: 14.0),
            hintText: "Search Any Food",
            suffixIcon: Material(
              elevation: 5.0,
              borderRadius: BorderRadius.circular(30.0),
              child: Icon(Icons.search_rounded, color: Colors.amber),
            ),
            border: InputBorder.none),
      ),
    );
  }
}
