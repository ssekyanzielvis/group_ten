import 'package:flutter/material.dart';

class MobileLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mobile Layout')),
      body: Center(child: Text('This is the mobile layout')),
    );
  }
}

class TabletLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tablet Layout')),
      body: Center(child: Text('This is the tablet layout')),
    );
  }
}

class DesktopLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Desktop Layout')),
      body: Center(child: Text('This is the desktop layout')),
    );
  }
}
