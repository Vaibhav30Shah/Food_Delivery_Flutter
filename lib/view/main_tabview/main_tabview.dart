import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:food_delivery/common/color_extension.dart';
import 'package:food_delivery/common_widget/tab_button.dart';
import 'package:food_delivery/view/home/view_all_pop_restaurant.dart';

import '../home/home_view.dart';
import '../menu/menu_view.dart';
import '../more/more_view.dart';
import '../offer/offer_view.dart';
import '../profile/profile_view.dart';

class MainTabView extends StatefulWidget {
  final String? userName;
  final String? userEmail;
  final String? userMobile;
  final String? userAddress;
  final String? userProfilePicture;
  const MainTabView({
    super.key,
    this.userName,
    this.userEmail,
    this.userMobile,
    this.userAddress,
    this.userProfilePicture,
  });
  @override
  State<MainTabView> createState() => _MainTabViewState();
}

class _MainTabViewState extends State<MainTabView> {
  int selctTab = 2;
  PageStorageBucket storageBucket = PageStorageBucket();
  Widget selectPageView = const HomeView();

  set setUserName(String? userName) {}

  void navigateToProfileView() {
    if (selctTab != 3) {
      selctTab = 3;
      selectPageView = ProfileView(
        userEmail: widget.userEmail,
        userMobile: widget.userMobile,
        userAddress: widget.userAddress,
        userName: widget.userName,
      );
    }
    if (mounted) {
      setState(() {});
    }
  }

  void initState() {
    super.initState();
    // _loadCSV();
    _fetchRestaurants();
  }

  List<Map<String, dynamic>> _data = [];

  Future<void> _loadCSV() async {
    final _rawData = await rootBundle.loadString("assets/csvs/restaurant.csv");
    List<List<dynamic>> _listData =
    const CsvToListConverter().convert(_rawData);

    List<String> headerRow = _listData.first.cast<String>().toList();

    List<Map<String, dynamic>> restaurants = _listData
        .skip(1) // Skip the header row
        .map((row) =>
        Map.fromIterables(
          headerRow
              .map((header) => header.toString()), // Cast keys to String
          row,
        ))
    // .where((restaurant) => restaurant['city'].contains(_userCity))
        .toList();

    setState(() {
      _data = restaurants;
    });
    print("Data came");
  }

  List<dynamic> _restaurants = [];

  Future<void> _fetchRestaurants() async {
    final response = await http.get(
        Uri.parse('https://food-app-cdn-new.onrender.com/api/get-restaurants'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        setState(() {
          _restaurants = data['restaurants'];
        });
      } else {
        print('Error: ${data['message']}');
      }
    } else {
      print('Failed to fetch restaurants');
    }
  }

  // @override
  // Widget build(BuildContext context) {
  //   if (_restaurants.isEmpty) {
  //     return Center(
  //       child: SpinKitWaveSpinner(
  //         color: TColor.primary,
  //         size: 50.0,
  //       ),
  //     );
  //   } else {
  //     return Scaffold(
  //       body: PageStorage(bucket: storageBucket, child: selectPageView),
  //       backgroundColor: const Color(0xfff5f5f5),
  //       floatingActionButtonLocation: FloatingActionButtonLocation
  //           .miniCenterDocked,
  //       floatingActionButton: SizedBox(
  //         width: 60,
  //         height: 60,
  //         child: FloatingActionButton(
  //           onPressed: () {
  //             if (selctTab != 2) {
  //               selctTab = 2;
  //               selectPageView = HomeView(userName: widget.userName);
  //             }
  //             if (mounted) {
  //               setState(() {});
  //             }
  //           },
  //           shape: const CircleBorder(),
  //           backgroundColor: selctTab == 2 ? TColor.primary : TColor
  //               .placeholder,
  //           child: Image.asset(
  //             "assets/img/tab_home.png",
  //             width: 30,
  //             height: 30,
  //           ),
  //         ),
  //       ),
  //       bottomNavigationBar: BottomAppBar(
  //         surfaceTintColor: TColor.white,
  //         shadowColor: Colors.black,
  //         elevation: 1,
  //         notchMargin: 12,
  //         height: 64,
  //         shape: const CircularNotchedRectangle(),
  //         child: SafeArea(
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceAround,
  //             children: [
  //               TabButton(
  //                 title: "Menu",
  //                 icon: "assets/img/tab_menu.png",
  //                 onTap: () {
  //                   if (selctTab != 0) {
  //                     selctTab = 0;
  //                     selectPageView = const MenuView();
  //                   }
  //                   if (mounted) {
  //                     setState(() {});
  //                   }
  //                 },
  //                 isSelected: selctTab == 0,
  //               ),
  //               TabButton(
  //                 title: "Restaurants",
  //                 icon: "assets/img/tab_offer.png",
  //                 onTap: () {
  //                   if (selctTab != 1) {
  //                     selctTab = 1;
  //                     selectPageView =
  //                         ViewAllPopularRestaurants(data: _restaurants);
  //                   }
  //                   if (mounted) {
  //                     setState(() {});
  //                   }
  //                 },
  //                 isSelected: selctTab == 1,
  //               ),
  //               const SizedBox(width: 40, height: 40),
  //               TabButton(
  //                 title: "Profile",
  //                 icon: "assets/img/tab_profile.png",
  //                 onTap: navigateToProfileView,
  //                 isSelected: selctTab == 3,
  //               ),
  //               TabButton(
  //                 title: "More",
  //                 icon: "assets/img/tab_more.png",
  //                 onTap: () {
  //                   if (selctTab != 4) {
  //                     selctTab = 4;
  //                     selectPageView = const MoreView();
  //                   }
  //                   if (mounted) {
  //                     setState(() {});
  //                   }
  //                 },
  //                 isSelected: selctTab == 4,
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    if (_restaurants.isEmpty) {
      return Center(
        child: SpinKitWaveSpinner(
          color: TColor.primary,
          size: 50.0,
          // controller: AnimationController(vsync: this, duration: const Duration(milliseconds: 1200)),
        ),
      );
    }
    return Scaffold(
      body: PageStorage(bucket: storageBucket, child: selectPageView),
      backgroundColor: const Color(0xfff5f5f5),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: SizedBox(
        width: 60,
        height: 60,
        child: FloatingActionButton(
          onPressed: () {
            if (selctTab != 2) {
              selctTab = 2;
              selectPageView = HomeView(userName: widget.userName);
            }
            if (mounted) {
              setState(() {});
            }
          },
          shape: const CircleBorder(),
          backgroundColor: selctTab == 2 ? TColor.primary : TColor.placeholder,
          child: Image.asset(
            "assets/img/tab_home.png",
            width: 30,
            height: 30,
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        surfaceTintColor: TColor.white,
        shadowColor: Colors.black,
        elevation: 1,
        notchMargin: 12,
        height: 64,
        shape: const CircularNotchedRectangle(),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TabButton(
                  title: "Menu",
                  icon: "assets/img/tab_menu.png",
                  onTap: () {
                    if (selctTab != 0) {
                      selctTab = 0;
                      selectPageView = const MenuView();
                    }
                    if (mounted) {
                      setState(() {});
                    }
                  },
                  isSelected: selctTab == 0),
              TabButton(
                  title: "Restaurants",
                  icon: "assets/img/tab_offer.png",
                  onTap: () {
                    if (selctTab != 1) {
                      selctTab = 1;
                      selectPageView = OfferView();
                    }
                    if (mounted) {
                      setState(() {});
                    }
                  },
                  isSelected: selctTab == 1),


                const  SizedBox(width: 40, height: 40, ),

            TabButton(
              title: "Profile",
              icon: "assets/img/tab_profile.png",
              onTap: navigateToProfileView,
              isSelected: selctTab == 3,
            ),
              TabButton(
                  title: "More",
                  icon: "assets/img/tab_more.png",
                  onTap: () {
                    if (selctTab != 4) {
                      selctTab = 4;
                      selectPageView = const MoreView();
                    }
                    if (mounted) {
                      setState(() {});
                    }
                  },
                  isSelected: selctTab == 4),
            ],
          ),
        ),
      ),
    );
  }
}