import 'package:flutter/material.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:food_delivery/common/color_extension.dart';
import 'package:food_delivery/common_widget/round_textfield.dart';
import 'package:food_delivery/view/menu/restaurant_menu.dart';
import 'package:geolocator/geolocator.dart';

import '../../common/globs.dart';
import '../../common/service_call.dart';
import '../../common_widget/category_cell.dart';
import '../../common_widget/most_popular_cell.dart';
import '../../common_widget/popular_resutaurant_row.dart';
import '../../common_widget/recent_item_row.dart';
import '../../common_widget/view_all_title_row.dart';
import '../more/my_order_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  TextEditingController txtSearch = TextEditingController();
  Position? _currentPosition;
  static String add="";
  var first;
  List catArr = [
    {"image": "assets/img/cat_offer.png", "name": "Offers"},
    {"image": "assets/img/cat_sri.png", "name": "South Indian"},
    {"image": "assets/img/cat_3.png", "name": "Italian"},
    {"image": "assets/img/cat_4.png", "name": "North Indian"},
  ];

  List popArr = [
    {
      "image": "assets/img/res_1.png",
      "name": "Dominoz Pizza",
      "rate": "4.9",
      "rating": "124",
      "type": "Cafa",
      "food_type": "Western Food"
    },
    {
      "image": "assets/img/img.png",
      "name": "Sankalp Restaurant",
      "rate": "4.9",
      "rating": "124",
      "type": "Cafa",
      "food_type": "South Indian"
    },
    {
      "image": "assets/img/res_3.png",
      "name": "Dangee Dums",
      "rate": "4.9",
      "rating": "124",
      "type": "Cafa",
      "food_type": "Bakery"
    },
  ];

  List mostPopArr = [
    {
      "image": "assets/img/m_res_1.png",
      "name": "Coffee by De-bella",
      "rate": "4.9",
      "rating": "124",
      "type": "Cafa",
      "food_type": "Western Food"
    },
    {
      "image": "assets/img/m_res_2.png",
      "name": "Café de Noir",
      "rate": "4.9",
      "rating": "124",
      "type": "Cafa",
      "food_type": "Western Food"
    },
  ];

  List recentArr = [
    {
      "image": "assets/img/item_1.png",
      "name": "Mulberry Pizza",
      "rate": "4.9",
      "rating": "124",
      "type": "Cafa",
      "food_type": "Western Food"
    },
    {
      "image": "assets/img/item_2.png",
      "name": "Starbucks",
      "rate": "4.9",
      "rating": "124",
      "type": "Cafa",
      "food_type": "Western Food"
    },
    {
      "image": "assets/img/item_3.png",
      "name": "Pizza Rush Hour",
      "rate": "4.9",
      "rating": "124",
      "type": "Cafa",
      "food_type": "Western Food"
    },
  ];

  Future<Position> getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      // if (permission == LocationPermission.denied) {
      //   return ;
      // }
    }
    return await Geolocator.getCurrentPosition();
  }

  @override
  void initState() {
    super.initState();
    _fetchLocation();
  }

  void _fetchLocation() async {
    Position position = await getCurrentLocation();
    final coordinates= new Coordinates(position.latitude,position.longitude);
    var address=await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first=address.first;
    add=first.addressLine.toString();
  print(add);
    setState(() {
      _currentPosition = position;
    });
    print(_currentPosition!.latitude+_currentPosition!.longitude);

  }


  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    bool isValentinesDay = now.month == 2 && now.day == 14;
    bool isHoli = now.month == 2 && now.day == 28;

    String greet="";
    var time=now.hour;
    print(time);
    if(time>=6 && time<12)
      greet="Morning";
    else if(time>12 && time<=17)
      greet="Afternoon";
    else
      greet="Evening";

    Color backgroundColor;
    if (isValentinesDay) {
      backgroundColor = Colors.pink.withOpacity(0.5);
    } else if (isHoli) {
      backgroundColor = Colors.orange.withOpacity(0.5);
    } else {
      backgroundColor = Colors.purple.withOpacity(0.5);
    }
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [backgroundColor,Colors.white],
            begin: Alignment.topLeft
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                const SizedBox(
                  height: 46,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            "Good $greet ${ServiceCall.userPayload[KKey.name] ?? ""}!",
                            // "Good $greet ${Widget.userName} ?? ""}!",
                            style: TextStyle(
                                color: TColor.primaryText,
                                fontSize: 20,
                                fontWeight: FontWeight.w800),
                          ),

                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MyOrderView()));
                        },
                        icon: Image.asset(
                          "assets/img/shopping_cart.png",
                          width: 25,
                          height: 25,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Delivering to",
                        style:
                            TextStyle(color: TColor.secondaryText, fontSize: 11),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                             add.toString(),
                              style: TextStyle(
                                  color: TColor.primaryText,
                                  overflow: TextOverflow.visible,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                          const SizedBox(
                            width: 25,
                          ),
                          Image.asset(
                            "assets/img/dropdown.png",
                            width: 12,
                            height: 12,
                          )
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: RoundTextfield(
                    hintText: "Search Food",
                    controller: txtSearch,
                    left: Container(
                      alignment: Alignment.center,
                      width: 30,
                      child: Image.asset(
                        "assets/img/search.png",
                        width: 20,
                        height: 20,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    itemCount: catArr.length,
                    itemBuilder: ((context, index) {
                      var cObj = catArr[index] as Map? ?? {};
                      return CategoryCell(
                        cObj: cObj,
                        onTap: () {},
                      );
                    }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ViewAllTitleRow(
                    title: "Popular Restaurants",
                    onView: () {},
                  ),
                ),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: popArr.length,
                  itemBuilder: ((context, index) {
                    var pObj = popArr[index] as Map? ?? {};
                    return PopularRestaurantRow(
                      pObj: pObj,
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> RestaurantMenu()));
                      },
                    );
                  }),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ViewAllTitleRow(
                    title: "Most Popular",
                    onView: () {},
                  ),
                ),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    itemCount: mostPopArr.length,
                    itemBuilder: ((context, index) {
                      var mObj = mostPopArr[index] as Map? ?? {};
                      return MostPopularCell(
                        mObj: mObj,
                        onTap: () {},
                      );
                    }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ViewAllTitleRow(
                    title: "Recent Items",
                    onView: () {},
                  ),
                ),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  itemCount: recentArr.length,
                  itemBuilder: ((context, index) {
                    var rObj = recentArr[index] as Map? ?? {};
                    return RecentItemRow(
                      rObj: rObj,
                      onTap: () {},
                    );
                  }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
