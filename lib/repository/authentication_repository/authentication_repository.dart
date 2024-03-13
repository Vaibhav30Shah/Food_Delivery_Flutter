import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:food_delivery/view/login/login_view.dart';
import 'package:food_delivery/view/login/sing_up_view.dart';
import 'package:food_delivery/view/on_boarding/on_boarding_view.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthenticationRepository extends GetxController{
  static AuthenticationRepository get instance => Get.find();

  final deviceStorage =GetStorage();
  final _auth=FirebaseAuth.instance;

  @override
  void onReady() {
    FlutterNativeSplash.remove();
    screenRedirect();
  }

  screenRedirect() async{
    deviceStorage.writeIfNull("IsFirstTime", true);

    deviceStorage.read('IsFirstTime')!=true
      ? Get.offAll(()=>const LoginView())
        :Get.offAll(const SignUpView());
  }

  Future registerWithEmailAndPassword(String email, String password) async{
    try{
      return await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }
}