import 'package:flutter/cupertino.dart';
import 'package:food_delivery/common/TFullScreenLoader.dart';
import 'package:food_delivery/common/loaders.dart';
import 'package:food_delivery/common/network_manager.dart';
import 'package:food_delivery/features/authentication/models/UserModel.dart';
import 'package:food_delivery/repository/authentication_repository/authentication_repository.dart';
import 'package:food_delivery/repository/user_repository/user_repository.dart';
import 'package:get/get.dart';

class SignupController extends GetxController{
  static SignupController get instance=>Get.find();

  final hidePassword=true.obs;
  final userid=1;
  final txtName = TextEditingController();
  final txtMobile = TextEditingController();
  final txtAddress = TextEditingController();
  final txtEmail = TextEditingController();
  final txtPassword = TextEditingController();
  final txtConfirmPassword = TextEditingController();
  GlobalKey<FormState> signupFormKey=GlobalKey<FormState>();

  void signup() async{
    try{
      //loading
      TFullScreenLoader.openLoadingDialog("We are processing your information...", "Image");

      //internet
      final isConnected=await NetworkManager.instance.isConnected();
      if(!isConnected){
        return;
      }

      //validation
      if(!signupFormKey.currentState!.validate()){
        return;
      }

      //register user in firebase
      final user=await AuthenticationRepository.instance.registerWithEmailAndPassword(txtEmail.text.trim(), txtPassword.text.trim());

      //save authenticated data
      final newUser=UserModel(id:user.user!.uid, fullName: txtName.text.trim(), email: txtEmail.text.trim(), phoneNo: txtMobile.text.trim(), password: txtPassword.text.trim());

      final userRepository=Get.put(UserRepository());
      await userRepository.saveUserRecord(user);

      TLoaders.successSnackBar(title: 'Success', message: 'Your Account is created.');

    }catch(e){
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
    finally{
      TFullScreenLoader.stopLoading();
    }
}
}