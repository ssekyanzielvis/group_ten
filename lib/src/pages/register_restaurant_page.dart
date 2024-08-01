import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../models/restaurant_model.dart';
import '../pages/bugdet.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class RegisterRestaurantPage extends StatefulWidget {
  const RegisterRestaurantPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegisterRestaurantPageState createState() => _RegisterRestaurantPageState();
}

class _RegisterRestaurantPageState extends State<RegisterRestaurantPage> {
  final restaurantRepo = Get.put(RestaurantRepository());
  final _formKey = GlobalKey<FormState>();
  late String _restaurantName, _password;
  bool _isLogin = false;

  void _toggleFormType() {
    setState(() {
      _isLogin = !_isLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLogin ? 'Login Restaurant' : 'Register Restaurant'),
        backgroundColor: Colors.deepOrange, // Replace with your desired color
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orangeAccent, Colors.deepOrange],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Restaurant Name',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(Icons.restaurant),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a restaurant name';
                        }
                        return null;
                      },
                      onSaved: (value) => _restaurantName = value!,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(Icons.lock),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.length < 8) {
                          return 'Please enter a password with at least 8 characters';
                        }
                        return null;
                      },
                      onSaved: (value) => _password = value!,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          if (_isLogin) {
                            _loginRestaurant();
                          } else {
                            _registerRestaurant();
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 15),
                        iconColor: Colors.deepOrange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(_isLogin ? 'Login' : 'Register'),
                    ),
                    TextButton(
                      onPressed: _toggleFormType,
                      child: Text(_isLogin
                          ? 'Don\'t have an account? Register'
                          : 'Already have an account? Login'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> createRestaurant(Restaurant restaurant) async {
    await restaurantRepo.createRestaurant(restaurant);
  }

  void _registerRestaurant() async {
    try {
      final docRef =
          await FirebaseFirestore.instance.collection('restaurants').add({
        'name': _restaurantName,
        'password': _password,
      });

      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(
          builder: (context) => RestaurantHomePage(
            restaurantId: docRef.id,
          ),
        ),
      );
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration failed: $e')),
      );
    }
  }

  void _loginRestaurant() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('restaurants')
          .where('name', isEqualTo: _restaurantName)
          .where('password', isEqualTo: _password)
          .get();

      if (snapshot.docs.isNotEmpty) {
        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
            builder: (context) => RestaurantHomePage(
              restaurantId: snapshot.docs.first.id,
            ),
          ),
        );
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid restaurant name or password')),
        );
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: $e')),
      );
    }
  }
}

class RestaurantHomePage extends StatefulWidget {
  final String restaurantId;

  const RestaurantHomePage({super.key, required this.restaurantId});

  @override
  // ignore: library_private_types_in_public_api
  _RestaurantHomePageState createState() => _RestaurantHomePageState();
}

class _RestaurantHomePageState extends State<RestaurantHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant Home Page'),
        backgroundColor: Colors.deepOrange,
        actions: [
          TextButton.icon(
            icon: Stack(
              children: [
                const Icon(
                  Icons.notifications,
                  color: Colors.white,
                ),
                Positioned(
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(1),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 12,
                      minHeight: 12,
                    ),
                    child: const Text(
                      '1', // Adjust this part as per your logic to show the notification count
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            label: const Text(
              'View Notifications',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('restaurants')
            .doc(widget.restaurantId)
            .collection('foods')
            .where('restaurantName',
                isEqualTo: widget.restaurantId) // Filtering by restaurantName
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GridView.builder(
              padding: const EdgeInsets.all(10.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2 / 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot food = snapshot.data!.docs[index];
                return Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      food['imageUrl'] != null
                          ? Image.network(
                              food['imageUrl'],
                              height: 100,
                              fit: BoxFit.cover,
                            )
                          : Container(height: 100),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              food['foodName'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'UGX ${food['price']}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.deepOrange,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.deepOrange,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddFoodPage(
                    restaurantId: widget.restaurantId,
                  ),
                ),
              );
            },
            child: const Text(
              'Add Food',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}

class AddFoodPage extends StatefulWidget {
  final String restaurantId;

  const AddFoodPage({super.key, required this.restaurantId});

  @override
  // ignore: library_private_types_in_public_api
  _AddFoodPageState createState() => _AddFoodPageState();
}

class _AddFoodPageState extends State<AddFoodPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _restaurantNameController =
      TextEditingController();
  final TextEditingController _restaurantPhoneController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  File? _image;
  String? _downloadURL;

  @override
  void dispose() {
    _restaurantNameController.dispose();
    _restaurantPhoneController.dispose();
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        if (kIsWeb) {
          _image = File(pickedFile.path); // This will work only on Android/iOS
        } else {
          _image = File(pickedFile.path);
        }
      });

      if (_image != null) {
        await _uploadImage();
      }
    } else {
      if (kDebugMode) {
        print('No image selected.');
      }
    }
  }

  Future<void> _uploadImage() async {
    try {
      String filePath = 'uploads/${widget.restaurantId}/${DateTime.now()}.png';
      Reference ref = FirebaseStorage.instance.ref().child(filePath);

      UploadTask uploadTask = ref.putFile(_image!);

      await uploadTask.whenComplete(() => null);
      String downloadURL = await ref.getDownloadURL();

      setState(() {
        _downloadURL = downloadURL;
      });

      if (kDebugMode) {
        print('File uploaded successfully. Download URL: $downloadURL');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error uploading file: $e');
      }
    }
  }

  Future<void> _saveFood() async {
    if (_formKey.currentState!.validate() && _downloadURL != null) {
      await FirebaseFirestore.instance
          .collection('restaurants')
          .doc(widget.restaurantId)
          .collection('foods')
          .add({
        'restaurantName': _restaurantNameController.text,
        'restaurantPhoneNumber': _restaurantPhoneController.text,
        'foodName': _nameController.text,
        'price': _priceController.text,
        'imageUrl': _downloadURL,
      });

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Food added successfully')),
      );

      _restaurantNameController.clear();
      _restaurantPhoneController.clear();
      _nameController.clear();
      _priceController.clear();
      setState(() {
        _image = null;
        _downloadURL = null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please fill all fields and upload an image')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Food'),
        backgroundColor: Colors.deepOrange, // Set the AppBar background color
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _restaurantNameController,
                decoration: const InputDecoration(
                  labelText: 'Restaurant Name',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the restaurant name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _restaurantPhoneController,
                decoration: const InputDecoration(
                  labelText: 'Restaurant Phone Number',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the restaurant phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Food Name',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the food name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the price';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickImage,
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  backgroundColor: Colors.deepOrange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Upload Image'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveFood,
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  backgroundColor: Colors.deepOrange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Add Food',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//import 'dart:nativewrappers/_internal/vm/lib/core_patch.dart';

class RestaurantRepository extends GetxController {
  static RestaurantRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  createRestaurant(Restaurant restaurant) async {
    try {
      await _db
          .collection('restaurants')
          .doc(restaurant.rid)
          .set(restaurant.toJson())
          .whenComplete(
            () => Get.snackbar(
              "Success",
              "Mission Success",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green.withOpacity(0.1),
              colorText: Colors.blue,
            ),
          );
    } catch (error) {
      Get.snackbar(
        "Error",
        "Something Wrong happened. Please try again",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.blue,
      );
      if (kDebugMode) {
        print(error.toString());
      }
    }
  }
}
