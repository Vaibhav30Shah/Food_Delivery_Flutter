import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:food_delivery/view/home/cuisine_wise_restaurants.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:food_delivery/common/color_extension.dart';
import 'package:food_delivery/common/db_helper.dart';
import 'package:food_delivery/common_widget/round_textfield.dart';
import 'package:food_delivery/models/restaurant_model.dart';
import 'package:food_delivery/view/home/view_all_pop_restaurant.dart';
import 'package:food_delivery/view/menu/restaurant_menu.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sqflite/sqflite.dart';
import '../../common/globs.dart';
import '../../common/service_call.dart';
import '../../common_widget/category_cell.dart';
import '../../common_widget/most_popular_cell.dart';
import '../../common_widget/popular_resutaurant_row.dart';
import '../../common_widget/recent_item_row.dart';
import '../../common_widget/view_all_title_row.dart';
import '../more/my_order_view.dart';

class HomeView extends StatefulWidget {
  final String? userName;

  const HomeView({super.key, this.userName});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  TextEditingController txtName = TextEditingController();
  TextEditingController txtSearch = TextEditingController();
  Position? _currentPosition;
  static String add = "";
  var first;

  List imgs=[
    {},
  ];

  List<Map<String, dynamic>> _data = [];

  Future<void> _loadCSV() async {
    final _rawData = await rootBundle.loadString("assets/csvs/restaurant.csv");
    List<List<dynamic>> _listData =
        const CsvToListConverter().convert(_rawData);

    List<String> headerRow = _listData.first.cast<String>().toList();

    List<Map<String, dynamic>> restaurants = _listData
        .skip(1) // Skip the header row
        .map((row) => Map.fromIterables(
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

  // Future<List<Restaurant>> getRestaurants() async {
  //   Database? db = await DatabaseHelper.instance.database;
  //   List<Map<String, dynamic>> results = await db!.query('restaurants');
  //
  //   // Convert the list of maps into a list of Restaurant objects
  //   List<Restaurant> restaurants = results.map((map) => Restaurant.fromMap(map)).toList();
  //   return restaurants;
  // }

  List catArr = [
    {"image": "assets/img/cuisines/gujarati.jpg", "name": "Gujarati"},
    {"image": "assets/img/cat_offer.png", "name": "Mexican"},
    {"image": "assets/img/cat_sri.png", "name": "South Indian"},
    {"image": "assets/img/cat_3.png", "name": "Italian"},
    {"image": "assets/img/cuisines/thali.jpg", "name": "Thali"},
    {"image": "assets/img/cat_4.png", "name": "North Indian"},
    {"image": "assets/img/cuisines/chinese.jpg", "name": "Chinese"},
    {"image": "assets/img/cuisines/chaat.jpg", "name": "Chaat"},
    {"image": "assets/img/cuisines/fastfood.jpg", "name": "Fast Food"},
    {"image": "assets/img/cuisines/juice.jpeg", "name": "Juices"},
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
  String? _userCity;

  Future<void> _getUserLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        String city = placemark.locality ?? '';
        setState(() {
          _userCity = city;
        });
      }
    } catch (e) {
      print('Error getting user location: $e');
    }
  }

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
    _getUserLocation();
    _fetchRestaurants();
    // _loadCSV();
    txtName.text = widget.userName ?? '';
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

  void _fetchLocation() async {
    Position position = await getCurrentLocation();
    final coordinates = new Coordinates(position.latitude, position.longitude);
    var address =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = address.first;
    add = first.addressLine.toString();
    print(add);
    setState(() {
      _currentPosition = position;
    });
    print(_currentPosition!.latitude + _currentPosition!.longitude);
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    bool isValentinesDay = now.month == 2 && now.day == 14;
    bool isHoli = now.month == 2 && now.day == 28;

    String greet = "";
    var time = now.hour;
    print(time);
    if (time >= 6 && time < 12)
      greet = "Morning";
    else if (time > 12 && time <= 17)
      greet = "Afternoon";
    else
      greet = "Evening";

    Color backgroundColor;
    if (isValentinesDay) {
      backgroundColor = Colors.pink.withOpacity(0.5);
    } else if (isHoli) {
      backgroundColor = Colors.orange.withOpacity(0.5);
    } else {
      backgroundColor = Colors.orange.withOpacity(0.5);
    }

    if (_userCity == null) {
      return Center(
        child: SpinKitWaveSpinner(
          color: TColor.primary,
          size: 50.0,
          // controller: AnimationController(vsync: this, duration: const Duration(milliseconds: 1200)),
        ),
      );
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [backgroundColor, Colors.white],
              begin: Alignment.topLeft),
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
                          Container(
                            width: 300,
                            child: Text(
                              "Good $greet ${ServiceCall.userPayload[KKey.name] ?? ""}${txtName.text} !",
                              // "Good $greet ${Widget.userName} ?? ""}!",
                              style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  color: TColor.primaryText,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800),
                            ),
                          ),
                        ],
                      ),
                      // IconButton(
                      //   onPressed: () {
                      //     Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //             builder: (context) => const MyOrderView()));
                      //   },
                      //   icon: Image.asset(
                      //     "assets/img/shopping_cart.png",
                      //     width: 25,
                      //     height: 25,
                      //   ),
                      // ),
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
                        style: TextStyle(
                            color: TColor.secondaryText, fontSize: 11),
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
                          // Image.asset(
                          //   "assets/img/dropdown.png",
                          //   width: 12,
                          //   height: 12,
                          // )
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
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CuisineWiseRestaurants(
                                      name: cObj['name'],
                                  )));
                        },
                      );
                    }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ViewAllTitleRow(
                    title: "Popular Restaurants",
                    onView: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ViewAllPopularRestaurants(
                                  data: _restaurants)));
                    },
                  ),
                ),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: _restaurants.length > 5 ? 5 : _restaurants.length,
                  itemBuilder: ((context, index) {
                    var pObj = _restaurants[index];
                    return PopularRestaurantRow(
                      pObj: pObj,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    RestaurantMenu(restaurant: pObj)));
                      },
                    );
                  }),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ViewAllTitleRow(
                    title: "Most Popular",
                    onView: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ViewAllPopularRestaurants(
                                  data: _restaurants)));
                    },
                  ),
                ),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    itemCount:  _restaurants.where((mObj) => mObj["rating"] > 4.5).length > 10?10:_restaurants.where((mObj) => mObj["rating"] > 4.5).length,
                    itemBuilder: ((context, index) {
                      var mObj =  _restaurants.where((mObj) => mObj["rating"] > 4.5).toList()[index];
                      if (mObj["rating"] > 3)
                        return MostPopularCell(
                          mObj: mObj,
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        RestaurantMenu(restaurant: mObj)));
                          },
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
