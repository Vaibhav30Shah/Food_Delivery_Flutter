import 'package:flutter/material.dart';
import 'package:food_delivery/authentication/authentication_helper.dart';
import 'package:food_delivery/view/login/login_view.dart';
import 'package:food_delivery/view/login/sing_up_view.dart';
import 'package:food_delivery/view/login/welcome_view.dart';
import 'package:food_delivery/view/main_tabview/main_tabview.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/globs.dart';

class StartupView extends StatefulWidget {
  const StartupView({super.key});

  @override
  State<StartupView> createState() => _StarupViewState();
}

class _StarupViewState extends State<StartupView> {
  @override
  void initState() {
    super.initState();
    goWelcomePage();
    checkLoginStatus();
  }

  void goWelcomePage() async {
    await Future.delayed(const Duration(seconds: 3));
    welcomePage();
  }

  void welcomePage() {
    if (Globs.udValueBool(Globs.userLogin)) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const LoginView()));
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const SignUpView()));
    }
  }

  void checkLoginStatus() async {
    bool isLogIn = await isLoggedIn();
    String? userName = await getUserName();
    if (isLogIn) {
      // User is logged in, navigate to MainTabView
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainTabView(userName: userName ?? 'User')),
      );
    } else {
      // User is not logged in, navigate to LoginView
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginView()),
      );
    }
  }

  Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    // Check if userId exists
    if (userId != null) {
      // User is logged in
      return true;
    } else {
      // User is not logged in
      return false;
    }
  }

  Future<String?> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userName');
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            "assets/img/splash_bg.png",
            width: media.width,
            height: media.height,
            fit: BoxFit.cover,
          ),
          Image.asset(
            "assets/img/logo.png",
            width: media.width * 0.55,
            height: media.width * 0.55,
            fit: BoxFit.contain,
          ),
          Navigator(onGenerateRoute: (settings) {
            return MaterialPageRoute(
              builder: (context) {
                return FutureBuilder<bool>(
                  future: isLoggedIn(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data!) {
                      return MainTabView(userName: getUserName().toString() ?? 'User'); // User is logged in
                    } else {
                      return SignUpView(); // User is not logged in
                    }
                  },
                );
              },
            );
          })
        ],
      ),
    );
  }
}
