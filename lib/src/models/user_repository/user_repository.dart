//import 'dart:nativewrappers/_internal/vm/lib/core_patch.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
//import 'package:vm_service/vm_service.dart';
import '../user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  createUser(User user) async {
    try {
      await _db.collection('users').doc(user.uid).set(user.toJson());
      Get.snackbar(
        "Success",
        "Mission Success",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.blue,
      );
    } catch (error) {
      Get.snackbar(
        "Error",
        "Something Wrong happened. Please try again",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.blue,
      );
      print(error.toString());
    }
  }
}
