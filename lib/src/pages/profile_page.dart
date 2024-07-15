import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: library_prefixes
import '../models/user_model.dart' as UserModel;
import '../screens/edit_profile_screen.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _fetchUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Error fetching profile: ${snapshot.error}'));
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('No profile data available.'));
          } else {
            try {
              Map<String, dynamic> data =
                  snapshot.data!.data() as Map<String, dynamic>;

              UserModel.User userProfile = UserModel.User(
                uid: data['uid'] ?? '',
                name: data['name'] ?? '',
                email: data['email'] ?? '',
                photoUrl: data['photoUrl'] ?? '',
                dob: data['dob'] ?? '',
                location: data['location'] ?? '',
                phoneNumber: data['phoneNumber'] ?? '',
              );

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: userProfile.photoUrl.isNotEmpty
                            ? NetworkImage(userProfile.photoUrl)
                            : const AssetImage(
                                'assets/default_profile_image.png'),
                        backgroundColor: Colors.grey.shade300,
                      ),
                      const SizedBox(height: 20),
                      _buildProfileItem(Icons.person, 'Name', userProfile.name),
                      const SizedBox(height: 20),
                      _buildProfileItem(
                          Icons.email, 'Email', userProfile.email),
                      const SizedBox(height: 20),
                      _buildProfileItem(Icons.calendar_today, 'Date of Birth',
                          userProfile.dob),
                      const SizedBox(height: 20),
                      _buildProfileItem(
                          Icons.location_on, 'Location', userProfile.location),
                      const SizedBox(height: 20),
                      _buildProfileItem(
                          Icons.phone, 'Phone Number', userProfile.phoneNumber),
                    ],
                  ),
                ),
              );
            } catch (e) {
              print('Error building profile page: $e');
              return Center(child: Text('Error building profile page'));
            }
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EditProfileScreen()),
          );
        },
        backgroundColor: Colors.deepOrange,
        child: const Icon(Icons.edit),
      ),
    );
  }

  Future<DocumentSnapshot> _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    return FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
  }

  Widget _buildProfileItem(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 30, color: Colors.deepOrange),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  value.isNotEmpty ? value : 'N/A',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
