import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart' as UserModel;
import 'package:firebase_storage/firebase_storage.dart';

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
  final TextEditingController _photoUrlController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  File? _profileImage;
  final String _uploadedImageUrl = '';

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

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
        _photoUrlController.text = userProfile.photoUrl;
        _dobController.text = userProfile.dob; // Add this line
        _locationController.text = userProfile.location;
        _phoneController.text = userProfile.phoneNumber;
      }
    }
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        UserModel.User userProfile = UserModel.User(
          uid: user.uid,
          name: _nameController.text,
          email: _emailController.text,
          photoUrl: imageUrl ?? _uploadedImageUrl,
          dob: _dobController.text, // Add this line
          location: _locationController.text,
          phoneNumber: _phoneController.text,
        );

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set(userProfile.toMap());

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Profile updated successfully'),
        ));

        Navigator.pop(context);
      }
    }
  }

  String? imageUrl = '';

  Future<String?> _uploadImageToFirebase() async {
    String imageUrl = '';

    if (_profileImage != null) {
      try {
        Reference ref = FirebaseStorage.instance.ref().child(
            'user_profile_images/${DateTime.now().millisecondsSinceEpoch}');
        UploadTask uploadTask = ref.putFile(_profileImage!);
        TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
        imageUrl = await taskSnapshot.ref.getDownloadURL();
      } catch (e) {
        print('Error uploading image to Firebase Storage: $e');
      }
    }

    return imageUrl;
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
                        : null,
                    backgroundColor: Colors.grey.shade300,
                    child: _profileImage == null
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

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _photoUrlController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _dobController.dispose();
    super.dispose();
  }
}
