import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:food_delivery/authentication/authentication_helper.dart';
import 'package:food_delivery/common/color_extension.dart';
import 'package:food_delivery/common/extension.dart';
import 'package:food_delivery/common/globs.dart';
import 'package:food_delivery/common/loaders.dart';
import 'package:food_delivery/common_widget/round_button.dart';
import 'package:food_delivery/common_widget/validation.dart';
import 'package:food_delivery/view/login/rest_password_view.dart';
import 'package:food_delivery/view/login/sing_up_view.dart';
import 'package:food_delivery/view/main_tabview/main_tabview.dart';
import 'package:food_delivery/view/on_boarding/on_boarding_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/service_call.dart';
import '../../common_widget/round_icon_button.dart';
import '../../common_widget/round_textfield.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  final authHelper = AuthenticationHelper();
  String? email;
  String? password;

  bool _obscureText = true;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    Future<void> storeUserData(String userId, String userName, String userEmail) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', userId);
      await prefs.setString('userName', userName);
      await prefs.setString('userEmail', userEmail);
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: ListView(
        children:[ Form(
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
                  "Login",
                  style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 30,
                      fontWeight: FontWeight.w800),
                ),
                Text(
                  "Add your details to login",
                  style: TextStyle(
                      color: TColor.secondaryText,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 25,
                ),
                TextFormField(
                  controller: txtEmail,
                  keyboardType: TextInputType.emailAddress,
                  // initialValue: 'Input text',
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.email_outlined),
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(100.0),
                      ),
                    ),
                  ),
                  validator: (value)=>TValidator.validateEmail(value),
                  onSaved: (val) {
                    email = val;
                  },
                ),
                const SizedBox(
                  height: 25,
                ),

                TextFormField(
                  controller: txtPassword,
                  keyboardType: TextInputType.visiblePassword,
                  // initialValue: 'Input text',
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        const Radius.circular(100.0),
                      ),
                    ),
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
                  obscureText: _obscureText,
                  onSaved: (val) {
                    password = val;
                  },
                  validator: (value)=>TValidator.validatePassword(value),
                ),

                const SizedBox(
                  height: 25,
                ),
                RoundButton(
                    title: "Login",
                    onPressed: () {
                      // btnLogin();

                      if (_formKey.currentState != null && _formKey.currentState!.validate()) {
                        _formKey.currentState!.save();

                        AuthenticationHelper()
                            .signIn(email: email!, password: password!)
                            .then((result) {
                          if (result == null) {
                            String userId = authHelper.user?.uid; // Get the user ID from Firebase Authentication
                            String userName = txtEmail.text.split('@')[0];
                            String userEmail = txtEmail.text;

                            // Retrieve user details from SharedPreferences
                            SharedPreferences.getInstance().then((prefs) {
                              String name=prefs.getString('userName') ?? '';
                              String userMobile = prefs.getString('userMobile') ?? '';
                              String userAddress = prefs.getString('userAddress') ?? '';

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MainTabView(
                                    userName: name,
                                    userEmail: userEmail,
                                    userMobile: userMobile,
                                    userAddress: userAddress,
                                  ),
                                ),
                              );
                            });
                          } else {
                            // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            //   content: Text(
                            //     result,
                            //     style: TextStyle(fontSize: 16),
                            //   ),
                            // ));
                            TLoaders.errorSnackBar(title: "Ah Snap", message: result);
                          }
                        });
                      }
                      else {
                        TLoaders.errorSnackBar(
                            title: "Ah Snap", message: "Enter Valid credentials");
                      }
                      Future<void> login() async {
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        await prefs.setString('token', KKey.authToken); // Store the token
                      }
                    }),
                const SizedBox(
                  height: 4,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ResetPasswordView(),
                      ),
                    );
                  },
                  child: Text(
                    "Forgot your password?",
                    style: TextStyle(
                        color: TColor.secondaryText,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  "or Login With",
                  style: TextStyle(
                      color: TColor.secondaryText,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 30,
                ),
                RoundIconButton(
                  icon: "assets/img/facebook_logo.png",
                  title: "Login with Facebook",
                  color: const Color(0xff367FC0),
                  onPressed: () {},
                ),
                const SizedBox(
                  height: 25,
                ),
                RoundIconButton(
                  icon: "assets/img/google_logo.png",
                  title: "Login with Google",
                  color: const Color(0xffDD4B39),
                  onPressed: () {},
                ),
                const SizedBox(
                  height: 80,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignUpView(),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Don't have an Account? ",
                        style: TextStyle(
                            color: TColor.secondaryText,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        "Sign Up",
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
      ]
      ),
    );
  }

  //TODO: Action
  void btnLogin() {
    if (!txtEmail.text.isEmail) {
      mdShowAlert(Globs.appName, MSG.enterEmail, () {});
      return;
    }

    if (txtPassword.text.length < 6) {
      mdShowAlert(Globs.appName, MSG.enterPassword, () {});
      return;
    }

    endEditing();

    serviceCallLogin({"email": txtEmail.text, "password": txtPassword.text, "push_token": "" });
  }

  //TODO: ServiceCall

  void serviceCallLogin(Map<String, dynamic> parameter) {
    Globs.showHUD();

    ServiceCall.post(parameter, SVKey.svLogin,
        withSuccess: (responseObj) async {
      Globs.hideHUD();
      if (responseObj[KKey.status] == "1") {
        
        Globs.udSet( responseObj[KKey.payload] as Map? ?? {} , Globs.userPayload);
        Globs.udBoolSet(true, Globs.userLogin);

          Navigator.pushAndRemoveUntil(context,  MaterialPageRoute(
            builder: (context) => const OnBoardingView(),
          ), (route) => false);
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
