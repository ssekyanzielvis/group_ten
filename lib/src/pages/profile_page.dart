import 'package:flutter/material.dart';
import '../screens/edit_profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_model.dart' as UserModel;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserModel.User? _userProfile;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (userData.exists && userData.data() != null) {
        _userProfile =
            UserModel.User.fromMap(userData.data() as Map<String, dynamic>);
        setState(() {
          _userProfile?.photoUrl = userData['photoUrl'];
          _userProfile?.email = userData['email'];
          _userProfile?.phoneNumber = userData['phoneNumber'];
          _userProfile?.location = userData['location'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 20),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blueAccent,
                Colors.cyanAccent,
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                "Profile",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 100.0,
                    height: 100.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 45, 40, 40)
                              .withOpacity(0.2),
                          spreadRadius: 5.0,
                          blurRadius: 7.0,
                          offset: const Offset(0.0, 3.0),
                        ),
                      ],
                      border: Border.all(color: Colors.white, width: 2),
                      image: DecorationImage(
                        image: _userProfile != null
                            ? NetworkImage(_userProfile!.photoUrl)
                            : const AssetImage("lib/assets/images/profile.jpg")
                                as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        _userProfile?.name ?? 'Loading...',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        _userProfile?.email ?? 'Loading...',
                        style: const TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 15.0,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const EditProfileScreen(),
                            ),
                          );
                          _loadUserData(); // Refresh profile data after editing
                        },
                        child: Container(
                          width: 100.0,
                          height: 40.0,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.lightGreen),
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.greenAccent,
                          ),
                          child: const Center(
                            child: Text(
                              'Edit',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 20.0,
              ),
              const Text(
                "Account",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                elevation: 5,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Icon(Icons.location_on, color: Colors.blueAccent),
                          SizedBox(width: 10),
                          Text("Location"),
                        ],
                      ),
                      Divider(
                        height: 10,
                        color: Colors.grey,
                        indent: 20.0,
                      ),
                      Row(
                        children: <Widget>[
                          Icon(Icons.visibility, color: Colors.blueAccent),
                          SizedBox(width: 10),
                          Text("Change Password"),
                        ],
                      ),
                      Divider(
                        height: 10,
                        color: Colors.grey,
                        indent: 20.0,
                      ),
                      Row(
                        children: <Widget>[
                          Icon(Icons.shopping_bag, color: Colors.blueAccent),
                          SizedBox(width: 10),
                          Text("Shipping"),
                        ],
                      ),
                      Divider(
                        height: 10,
                        color: Colors.grey,
                        indent: 20.0,
                      ),
                      Row(
                        children: <Widget>[
                          Icon(Icons.paypal, color: Colors.blueAccent),
                          SizedBox(width: 10),
                          Text("Payment"),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
