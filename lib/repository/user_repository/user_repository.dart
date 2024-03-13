import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/features/authentication/models/UserModel.dart';
import 'package:get/get.dart';

class UserRepository extends GetxController{
  static UserRepository get instance => Get.find();

  final _db=FirebaseFirestore.instance;

  Future<void> saveUserRecord(UserModel user) async{
    try{
      await _db.collection("user").doc(user.id).set(user.toJson());
    }catch(e){
      throw 'Something went wrong';
    }
  }

  createUser(UserModel user) async{
    await _db.collection("user").add(user.toJson())
        .whenComplete(() => Get.snackbar("Success", "Your Account has been created",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.withOpacity(0.1),
      colorText: Colors.green,
    ))
    .catchError((error, stackTrace){
      Get.snackbar("Error", "Something went wrong. Try Again",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
      print(error.toString());
    });
  }
}