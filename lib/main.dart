import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:food_delivery/authentication/authentication_helper.dart';
import 'package:food_delivery/bindings/general_bindings.dart';
import 'package:food_delivery/common/color_extension.dart';
import 'package:food_delivery/common/db_helper.dart';
import 'package:food_delivery/common/locator.dart';
import 'package:food_delivery/common/service_call.dart';
import 'package:food_delivery/view/login/login_view.dart';
import 'package:food_delivery/view/main_tabview/main_tabview.dart';
import 'package:food_delivery/view/on_boarding/startup_view.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'common/globs.dart';
import 'common/my_http_overrides.dart';

SharedPreferences? prefs;
void main() async {
  setUpLocator();
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  WidgetsFlutterBinding.ensureInitialized();
  // await dotenv.load(fileName: ".env");
  await Firebase.initializeApp();

  if(Globs.udValueBool(Globs.userLogin)) {
    ServiceCall.userPayload = Globs.udValue(Globs.userPayload);
  }

  DatabaseHelper.instance.database.then((_) {
    insertDataFromCSV();
  });

  // runApp(MyApp(defaultHome:  StartupView(),));
  String? userName = await getUserName();
  runApp(StreamBuilder<User?>(
    stream: AuthenticationHelper().authStateChanges(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const CircularProgressIndicator();
      } else if (snapshot.hasError) {
        return const Center(
          child: Text('Error initializing Firebase'),
        );
      } else if (snapshot.hasData) {
        return MyApp(defaultHome: MainTabView(userName: userName));
      } else {
        return MyApp(defaultHome: LoginView());
      }
    },
  ));
}

Future<String?> getUserName() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('name');
}


void insertDataFromCSV() async {
  String csvString = await rootBundle.loadString('assets/csvs/restaurant.csv');
  String csvFilePath = "assets/csvs/restaurant.csv";

  await DatabaseHelper.instance.insertFromCSV(csvString);
  print('Data inserted successfully from CSV.');
}
void configLoading() {
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.ring
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 5.0
    ..progressColor = TColor.primaryText
    ..backgroundColor = TColor.primary
    ..indicatorColor = Colors.yellow
    ..textColor = TColor.primaryText
    ..userInteractions = false
    ..dismissOnTap = false;
}

class MyApp extends StatefulWidget {
  final Widget defaultHome;
  const MyApp({super.key, required this.defaultHome});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _theme = '';

  @override
  void initState() {
    super.initState();
    _setTheme();
  }

  void _setTheme() {
    DateTime now = DateTime.now();
    if (now.month == 2 && now.day == 14) {
      setState(() {
        _theme = 'valentines';
      });
    } else if (now.month == 3 && now.day == 21) {
      setState(() {
        _theme = 'holi';
      });
    } else {
      setState(() {
        _theme = 'default';
      });
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    bool isValentinesDay = now.month == 2 && now.day == 27;
    bool isHoli = now.month == 3 && now.day == 21;

    Color backgroundColor;
    if (isValentinesDay) {
      backgroundColor = Colors.pink.withOpacity(0.5);
    } else if (isHoli) {
      backgroundColor = Colors.blue.withOpacity(0.5);
    } else {
      backgroundColor = Colors.white;
    }
    return GetMaterialApp(
      initialBinding: GeneralBindings(),
      title: 'Food Delivery',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        backgroundColor: backgroundColor,
      ),
      home: widget.defaultHome,
      navigatorKey: locator<NavigationService>().navigatorKey,
      onGenerateRoute: (routeSettings){
        switch (routeSettings.name) {
          case "welcome":
              return MaterialPageRoute(builder: (context) => const MainTabView(userName: "User") );
          case "Home":
              return MaterialPageRoute(builder: (context) => const MainTabView(userName: "User",) );
          default:
              return MaterialPageRoute(builder: (context) => Scaffold(
                body: Center(
                  child: Text("No path for ${routeSettings.name}")
                ),
              ) );
        }
      },
      builder: (context, child) {
        return FlutterEasyLoading(child: child);
      },
    );
  }
}

