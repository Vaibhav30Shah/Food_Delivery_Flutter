import 'package:flutter/material.dart';
import 'package:food_delivery/common/color_extension.dart';
import 'package:food_delivery/common_widget/tab_button.dart';

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
  const MainTabView({
    super.key,
    this.userName,
    this.userEmail,
    this.userMobile,
    this.userAddress,
  });
  @override
  State<MainTabView> createState() => _MainTabViewState();
}

class _MainTabViewState extends State<MainTabView> {
  int selctTab = 2;
  PageStorageBucket storageBucket = PageStorageBucket();
  Widget selectPageView = const HomeView();

  set setUserName(String? userName){}

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

  @override
  Widget build(BuildContext context) {
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
          backgroundColor: selctTab == 2 ? Colors.purpleAccent : TColor.placeholder,
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
                  title: "Offer",
                  icon: "assets/img/tab_offer.png",
                  onTap: () {
                    if (selctTab != 1) {
                      selctTab = 1;
                      selectPageView = const OfferView();
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
                      selectPageView = const  MoreView();
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
