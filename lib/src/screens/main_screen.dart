import 'package:flutter/material.dart';
import 'package:food_dash/src/pages/welcome_page_ui.dart';

import '../pages/order_page.dart';
import '../pages/favourite_page.dart';
import '../pages/profile_page.dart';
import '../widgets/auth_service.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentTabIndex = 0;

  List<Widget> pages = [];
  Widget currentPage = const WelcomePage();

  WelcomePage homePage = const WelcomePage();
  OrderPage orderPage = const OrderPage();
  FavoritesPage favouritePage = const FavoritesPage();
  ProfilePage profilePage = const ProfilePage();

  @override
  void initState() {
    super.initState();
    homePage = const WelcomePage();
    orderPage = const OrderPage();
    favouritePage = const FavoritesPage();
    profilePage = const ProfilePage();
    pages = [
      homePage,
      orderPage,
      favouritePage,
      profilePage,
    ];
    currentPage = pages[
        0]; // Initialize currentPage with the first page in the pages list
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Dash'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await AuthService().signOut();
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int index) {
          setState(() {
            currentTabIndex = index;
            currentPage = pages[index];
          });
        },
        currentIndex: currentTabIndex,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
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
