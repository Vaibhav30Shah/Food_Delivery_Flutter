import 'package:flutter/material.dart';
import 'package:food_delivery/common/color_extension.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class TLoaders{

  static warningSnackBar({required title, message = ''}) {
    Get.snackbar(title, message,
        isDismissible: true,
        shouldIconPulse: true,
        colorText: TColor.white,
        backgroundColor: Colors.orange,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        margin: EdgeInsets.all(20),
        icon: Icon(
          Iconsax.warning_2,
          color: TColor.white,
        ));
  }

  static errorSnackBar({required title, message = ''}) {
    Get.snackbar(title, message,
        isDismissible: true,
        shouldIconPulse: true,
        colorText: TColor.white,
        backgroundColor: Colors.red.shade600,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        margin: EdgeInsets.all(20),
        icon: Icon(
          Iconsax.warning_2,
          color: TColor.white,
        ));
  }

  static successSnackBar({required title, message = ''}) {
    Get.snackbar(title, message,
        isDismissible: true,
        shouldIconPulse: true,
        colorText: TColor.white,
        backgroundColor: Colors.green.shade600,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        margin: EdgeInsets.all(20),
        icon: Icon(
          Iconsax.warning_2,
          color: TColor.white,
        ));
  }
}