
import 'package:flutter/material.dart';
import 'package:food_delivery/common/TAnimationLoaderWidget.dart';
import 'package:food_delivery/common/color_extension.dart';
import 'package:food_delivery/utils/helper_functions.dart';
import 'package:get/get.dart';

class TFullScreenLoader {
  static void openLoadingDialog(String text, String animation) {
    showDialog(
      context: Get.overlayContext!,
      // Use Get.overlayContext for overlay dialogs
      barrierDismissible: false,
      // The dialog can't be dismissed by tapping outside it
      builder: (_) =>
          WillPopScope(
            onWillPop:() async {
              // Show a dialog and return false to prevent popping
              showDialog(
                  context: _,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Are you sure?'),
                      content: Text('Do you want to exit the app?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text('No'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: Text('Yes'),
                        ),
                      ],
                    );
                  },
              );
              return false; // Prevent popping
            },// Disable popping with the back button
            child: Container(
              color: THelperFunctions.isDarkMode(Get.context!)
                  ? TColor.placeholder
                  : TColor.white,
              width: double.infinity,
              height: double.infinity,
              child: Column(
                children: [
                  const SizedBox(height: 250), // Adjust the spacing as needed
                  TAnimationLoaderWidget(text: text, animation: animation),
                ],
              ),
            ),
          ),
    );
  }

  static stopLoading(){
    Navigator.of(Get.overlayContext!).pop();
  }
}