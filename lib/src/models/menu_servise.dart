import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'menu_item.dart';
import 'dart:io';

class MenuService {
  final DatabaseReference _database =
      FirebaseDatabase.instance.ref().child('menu_items');
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  Future<void> addMenuItem(MenuItem menuItem, File imageFile) async {
    try {
      // Upload image to Firebase Storage
      String? imageUrl = await uploadImage(imageFile);
      if (imageUrl == null) throw Exception("Failed to upload image");

      menuItem.imageUrl = imageUrl;

      // Save menu item to Firebase Realtime Database
      await _database.push().set(menuItem.toJson());
    } catch (e) {
      print('Error adding menu item: $e');
      rethrow;
    }
  }

  Future<String?> uploadImage(File imageFile) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageReference =
          _storage.ref().child('menu_images').child(fileName);
      UploadTask uploadTask = storageReference.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<List<MenuItem>> getMenuItems() async {
    try {
      DataSnapshot snapshot = await _database.get();
      List<MenuItem> menuItems = [];
      if (snapshot.value != null) {
        Map<dynamic, dynamic> values = snapshot.value as Map<dynamic, dynamic>;
        values.forEach((key, value) {
          menuItems.add(MenuItem.fromJson(Map<String, dynamic>.from(value)));
        });
      }
      return menuItems;
    } catch (e) {
      print('Error fetching menu items: $e');
      rethrow;
    }
  }

  Future<File?> pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile == null) return null;
      return File(pickedFile.path);
    } catch (e) {
      print('Error picking image: $e');
      return null;
    }
  }
}
