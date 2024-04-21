import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/authentication/authentication_helper.dart';
import 'package:food_delivery/view/login/login_view.dart';
import 'package:food_delivery/view/main_tabview/main_tabview.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('Error initializing Firebase'),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return StreamBuilder(
            stream: AuthenticationHelper().authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return MainTabView();
              } else {
                return LoginView();
              }
            },
          );
        }

        return const CircularProgressIndicator();
      },
    );
  }
}