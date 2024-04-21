import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_delivery/authentication/authentication_helper.dart';
import 'package:food_delivery/common/color_extension.dart';
import 'package:food_delivery/common/extension.dart';
import 'package:food_delivery/common/loaders.dart';
import 'package:food_delivery/common_widget/round_button.dart';
import 'package:food_delivery/common_widget/validation.dart';
import 'package:food_delivery/features/authentication/controllers/signup_controller.dart';
import 'package:food_delivery/view/login/login_view.dart';
import 'package:food_delivery/view/main_tabview/main_tabview.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/globs.dart';
import '../../common/service_call.dart';
import '../../common_widget/round_textfield.dart';
import '../on_boarding/on_boarding_view.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final _formKey = GlobalKey<FormState>();

  String? email;
  String? password;
  bool _obscureText = false;

  final txtName = new TextEditingController();
  final txtMobile =new TextEditingController();
  final txtAddress = new TextEditingController();
  final txtEmail = new TextEditingController();
  final txtPassword = new TextEditingController();
  final txtConfirmPassword = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignupController());
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 64,
                ),
                Text(
                  "Sign Up",
                  style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 30,
                      fontWeight: FontWeight.w800),
                ),
                Text(
                  "Add your details to sign up",
                  style: TextStyle(
                      color: TColor.secondaryText,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 25,
                ),
                TextFormField(
                  // hintText: "Name",
                  controller: txtName,
                  validator: (value) =>
                      TValidator.validateEmptyText('Name', value),
                  expands: false,
                  decoration: const InputDecoration(
                      labelText: 'Name', prefixIcon: Icon(Iconsax.user)),
                ),
                const SizedBox(
                  height: 25,
                ),
                TextFormField(
                  // hintText: "Email",
                  controller: txtEmail,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => TValidator.validateEmail(value),
                  onSaved: (val) {
                    email = val;
                  },
                  expands: false,
                  decoration: const InputDecoration(
                      labelText: 'Email', prefixIcon: Icon(Icons.email)),
                ),
                const SizedBox(
                  height: 25,
                ),
                TextFormField(
                  // hintText: "Mobile No",
                  controller: txtMobile,
                  keyboardType: TextInputType.phone,
                  validator: (value) => TValidator.validatePhoneNumber(value),
                  expands: false,
                  decoration: const InputDecoration(
                      labelText: 'Phone number', prefixIcon: Icon(Icons.call)),
                ),
                const SizedBox(
                  height: 25,
                ),
                TextFormField(
                  // hintText: "Address",
                  controller: txtAddress,
                  validator: (value) =>
                      TValidator.validateEmptyText('Address', value),
                  expands: false,
                  decoration: const InputDecoration(
                      labelText: 'Address',
                      prefixIcon: Icon(Iconsax.location_add)),
                ),
                const SizedBox(
                  height: 25,
                ),
                TextFormField(
                  // hintText: "Password",
                  controller: txtPassword,
                  // obscureText: true,
                  validator: (value) => TValidator.validatePassword(value),
                  // expands: controller.hidePassword.value,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Iconsax.password_check),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                      child: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                      ),
                    ),
                  ),
                  onSaved: (val) {
                    password = val;
                  },
                  obscureText: !_obscureText,
                  // suffixIcon:  IconButton(
                  //     onPressed: () => controller.hidePassword.value = !controller.hidePassword.value,
                  //     icon: Icon(controller.hidePassword.value ? Iconsax.eye_slash: Iconsax.eye)),
                ),
                const SizedBox(
                  height: 25,
                ),
                TextFormField(
                  // hintText: "Confirm Password",
                  controller: txtConfirmPassword,
                  obscureText: true,
                  validator: (value) {
                    if (value != txtPassword.text) {
                      return 'Password not match';
                    }
                    return null;
                  },
                  // validator: (value)=>TValidator.validatePassword(value),
                  expands: false,
                  decoration: const InputDecoration(
                      labelText: 'Confirm Password',
                      prefixIcon: Icon(Iconsax.password_check)),
                ),
                const SizedBox(
                  height: 25,
                ),
                RoundButton(
                    title: "Sign Up",
                    onPressed: () {
                      // controller.signup();

                      if (_formKey.currentState != null &&
                          _formKey.currentState!.validate()) {
                        _formKey.currentState!.save();

                        if (txtEmail.text.isNotEmpty &&
                            txtPassword.text.isNotEmpty) {
                          // Email and password are not empty, proceed with sign up
                          AuthenticationHelper().signUp(
                              email: txtEmail.text,
                              password: txtPassword.text,
                              name: txtName.text,
                              mobile: txtMobile.text,
                              address: txtAddress.text)
                              .then((result) {
                            if (result == null) {
                              // Store user details in SharedPreferences
                              SharedPreferences.getInstance().then((prefs) {
                                prefs.setString('userName', txtName.text);
                                prefs.setString('userEmail', txtEmail.text);
                                prefs.setString('userMobile', txtMobile.text);
                                prefs.setString('userAddress', txtAddress.text);
                              });

                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginView()));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                  result,
                                  style: TextStyle(fontSize: 16),
                                ),
                              ));
                            }
                          });
                        } else {
                          // Email or password is empty, show error message
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                              'Email and password cannot be empty',
                              style: TextStyle(fontSize: 16),
                            ),
                          ));
                        }
                      } else {
                        TLoaders.errorSnackBar(
                            title: "Ah Snap", message: "Enter Valid credentials");
                      }

                      //  Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder: (context) => const OTPView(),
                      //       ),
                      //     );
                    }),
                const SizedBox(
                  height: 30,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginView(),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Already have an Account? ",
                        style: TextStyle(
                            color: TColor.secondaryText,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        "Login",
                        style: TextStyle(
                            color: TColor.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //TODO: Action
  // void btnSignUp() {
  //
  //   if (txtName.text.isEmpty) {
  //     mdShowAlert(Globs.appName, MSG.enterName, () {});
  //     return;
  //   }
  //
  //   if (!txtEmail.text.isEmail) {
  //     mdShowAlert(Globs.appName, MSG.enterEmail, () {});
  //     return;
  //   }
  //
  //   if (txtMobile.text.isEmpty) {
  //     mdShowAlert(Globs.appName, MSG.enterMobile, () {});
  //     return;
  //   }
  //
  //   if (txtAddress.text.isEmpty) {
  //     mdShowAlert(Globs.appName, MSG.enterAddress, () {});
  //     return;
  //   }
  //
  //   if (txtPassword.text.length < 6) {
  //     mdShowAlert(Globs.appName, MSG.enterPassword, () {});
  //     return;
  //   }
  //
  //   if (txtPassword.text != txtConfirmPassword.text) {
  //     mdShowAlert(Globs.appName, MSG.enterPasswordNotMatch, () {});
  //     return;
  //   }
  //
  //   endEditing();
  //
  //   serviceCallSignUp({
  //     "name": txtName.text,
  //
  //     "mobile": txtMobile.text,
  //     "email": txtEmail.text,
  //     "address": txtAddress.text,
  //     "password": txtPassword.text,
  //     "push_token": "",
  //     "device_type": Platform.isAndroid ? "A" : "I"
  //   });
  // }

  //TODO: ServiceCall

  void serviceCallSignUp(Map<String, dynamic> parameter) {
    Globs.showHUD();

    ServiceCall.post(parameter, SVKey.svSignUp,
        withSuccess: (responseObj) async {
      Globs.hideHUD();
      if (responseObj[KKey.status] == "1") {
        Globs.udSet(responseObj[KKey.payload] as Map? ?? {}, Globs.userPayload);
        Globs.udBoolSet(true, Globs.userLogin);

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const OnBoardingView(),
            ),
            (route) => false);
      } else {
        mdShowAlert(Globs.appName,
            responseObj[KKey.message] as String? ?? MSG.fail, () {});
      }
    }, failure: (err) async {
      Globs.hideHUD();
      mdShowAlert(Globs.appName, err.toString(), () {});
    });
  }
}
