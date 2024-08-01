import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
// ignore: library_prefixes
import '../models/user_model.dart' as UserModel;

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  File? _profileImage;
  String _uploadedImageUrl = '';

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
      if (userData.exists) {
        UserModel.User userProfile =
            UserModel.User.fromMap(userData.data() as Map<String, dynamic>);
        _nameController.text = userProfile.name;
        _emailController.text = userProfile.email;
        _dobController.text = userProfile.dob;
        _locationController.text = userProfile.location;
        _phoneController.text = userProfile.phoneNumber;
        _uploadedImageUrl = userProfile.photoUrl;
      }
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadFile() async {
    if (_profileImage != null) {
      try {
        String filePath = 'profile_images/${DateTime.now()}.png';
        FirebaseStorage storage = FirebaseStorage.instance;
        Reference ref = storage.ref().child(filePath);
        await ref.putFile(_profileImage!);
        _uploadedImageUrl = await ref.getDownloadURL();
      } catch (e) {
        if (kDebugMode) {
          print('Error uploading file: $e');
        }
      }
    }
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await _uploadFile();

        UserModel.User userProfile = UserModel.User(
          uid: user.uid,
          name: _nameController.text,
          email: _emailController.text,
          photoUrl: _uploadedImageUrl,
          dob: _dobController.text,
          location: _locationController.text,
          phoneNumber: _phoneController.text,
        );

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set(userProfile.toMap());

        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Profile updated successfully'),
        ));

        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _profileImage != null
                        ? FileImage(_profileImage!)
                        : _uploadedImageUrl.isNotEmpty
                            ? NetworkImage(_uploadedImageUrl)
                            : null,
                    backgroundColor: Colors.grey.shade300,
                    child: _profileImage == null && _uploadedImageUrl.isEmpty
                        ? const Icon(Icons.add_a_photo,
                            size: 50, color: Colors.white)
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildTextFormField(
                controller: _nameController,
                label: 'Name',
                icon: Icons.person,
              ),
              const SizedBox(height: 20),
              _buildTextFormField(
                controller: _emailController,
                label: 'Email',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              _buildTextFormField(
                controller: _dobController,
                label: 'Date of Birth',
                icon: Icons.calendar_today,
              ),
              const SizedBox(height: 20),
              _buildTextFormField(
                controller: _locationController,
                label: 'Location',
                icon: Icons.location_on,
              ),
              const SizedBox(height: 20),
              _buildTextFormField(
                controller: _phoneController,
                label: 'Phone Number',
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(
                    iconColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Save Profile'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Colors.grey.shade200,
      ),
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $label';
        }
        return null;
      },
    );
  }
}
