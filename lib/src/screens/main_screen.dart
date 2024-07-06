import 'package:flutter/material.dart';

import '../pages/home_page.dart';
import '../pages/order_page.dart';
import '../pages/favourite_page.dart';
import '../pages/profile_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentTabIndex = 0;

  List<Widget> pages = [];
  Widget currentPage = HomePage();

  HomePage homePage = HomePage();
  OrderPage orderPage = OrderPage();
  FavoritesPage favouritePage = FavoritesPage();
  ProfilePage profilePage = ProfilePage();

  @override
  void initState() {
    super.initState();
    homePage = HomePage();
    orderPage = OrderPage();
    favouritePage = FavoritesPage();
    profilePage = ProfilePage();
    pages = [
      homePage,
      orderPage,
      favouritePage,
      profilePage,
    ];
    currentPage = pages[
        0]; // Initialize currentPage with the first page in the pages list
  }

  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int index) {
          setState(() {
            currentTabIndex = index;
            currentPage = pages[index];
          });
        },
        currentIndex: currentTabIndex,
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
      body: currentPage,
    );
  }
}
