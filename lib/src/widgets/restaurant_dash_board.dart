// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RestaurantDashboard extends StatefulWidget {
  const RestaurantDashboard({super.key});

  @override
  _RestaurantDashboardState createState() => _RestaurantDashboardState();
}

class _RestaurantDashboardState extends State<RestaurantDashboard> {
  final _formKey = GlobalKey<FormState>();
  String? _name, _address, _cuisine;
  List<Menuitem> _menuItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant Dashboard'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Name'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
              onSaved: (value) => _name = value,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Address'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter an address';
                }
                return null;
              },
              onSaved: (value) => _address = value,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Cuisine'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a cuisine';
                }
                return null;
              },
              onSaved: (value) => _cuisine = value,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  await updateRestaurantProfile();
                  await getMenuItems();
                }
              },
              child: const Text('Save Profile'),
            ),
            const SizedBox(height: 20),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _menuItems.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_menuItems[index].name),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      await deleteMenuitem(_menuItems[index].id);
                      await getMenuItems();
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await addMenuitem();
                await getMenuItems();
              },
              child: const Text('Add Menu Item'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> updateRestaurantProfile() async {
    const url = 'your_update_profile_api_endpoint';
    final params = {
      'name': _name,
      'address': _address,
      'cuisine': _cuisine,
    };
    final response = await http.put(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(params));
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print('Profile updated successfully');
      }
    } else {
      if (kDebugMode) {
        print('Error updating profile');
      }
    }
  }

  Future<void> getMenuItems() async {
    const url = 'your_get_menu_items_api_endpoint';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      setState(() {
        _menuItems =
            (jsonData as List).map((e) => Menuitem.fromJson(e)).toList();
      });
    } else {
      if (kDebugMode) {
        print('Error fetching menu items');
      }
    }
  }

  Future<void> addMenuitem() async {
    const url = 'your_add_menu_item_api_endpoint';
    final params = {
      'name': 'New Menu Item',
      'price': 10.99,
    };
    final response = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(params));
    if (response.statusCode == 201) {
      if (kDebugMode) {
        print('Menu item added successfully');
      }
    } else {
      if (kDebugMode) {
        print('Error adding menu item');
      }
    }
  }

  Future<void> deleteMenuitem(String id) async {
    final url = 'your_delete_menu_item_api_endpoint/$id';
    final response = await http.delete(Uri.parse(url));
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print('Menu item deleted successfully');
      }
    } else {
      if (kDebugMode) {
        print('Error deleting menu item');
      }
    }
  }
}

class Menuitem {
  final String id;
  final String name;
  final double price;

  Menuitem({required this.id, required this.name, required this.price});

  factory Menuitem.fromJson(Map<String, dynamic> json) {
    return Menuitem(
      id: json['id'],
      name: json['name'],
      price: json['price'],
    );
  }
}
