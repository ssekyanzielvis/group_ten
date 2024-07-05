import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;
  const Background({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(255, 83, 69, 164),
            Color.fromARGB(255, 66, 53, 165).withOpacity(0.8),
            Color.fromARGB(255, 75, 53, 165).withOpacity(0.6),
            Color.fromARGB(255, 121, 112, 159).withOpacity(0.4),
            Color.fromARGB(255, 70, 53, 165).withOpacity(0.2),
            Color(0xff6f35a5).withOpacity(0.1),
            Color(0xff6f35a5).withOpacity(0.05),
            Color(0xff6f35a5).withOpacity(0.025),
          ],
        ),
      ),
      child: child,
    );
  }
}

class BottomNavigationBarContainer extends StatelessWidget {
  final Widget child;
  const BottomNavigationBarContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      elevation: 0,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xff6f35a5), // kPrimaryColor
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 10),
              blurRadius: 50,
              color: const Color(0xff6f35a5).withOpacity(0.23),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}
