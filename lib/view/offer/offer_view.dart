import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:food_delivery/common/color_extension.dart';
import 'package:food_delivery/common_widget/round_button.dart';
import 'package:food_delivery/view/menu/restaurant_menu.dart';
import 'package:http/http.dart' as http;
import '../../common_widget/popular_resutaurant_row.dart';
import '../more/my_order_view.dart';

class OfferView extends StatefulWidget {
  const OfferView({super.key});

  @override
  State<OfferView> createState() => _OfferViewState();
}

class _OfferViewState extends State<OfferView> {
  TextEditingController txtSearch = TextEditingController();

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

  @override
  void initState() {
    super.initState();
    _fetchRestaurants();
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

  @override
  Widget build(BuildContext context) {
    if (_restaurants.isEmpty) {
      return Scaffold(
          body: Center(
        child: SpinKitWaveSpinner(
          color: TColor.primary,
          size: 50.0,
          // controller: AnimationController(vsync: this, duration: const Duration(milliseconds: 1200)),
        ),
      ));
    }
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange.withOpacity(0.6), Colors.white],
            begin: Alignment.topRight
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 46,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Explore More Restaurants",
                        style: TextStyle(
                            color: TColor.primaryText,
                            fontSize: 20,
                            fontWeight: FontWeight.w800),
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
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 20),
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Text(
                //         "Find discounts, Offers special\nmeals and more!",
                //         style: TextStyle(
                //             color: TColor.secondaryText,
                //             fontSize: 14,
                //             fontWeight: FontWeight.w500),
                //       ),
                //     ],
                //   ),
                // ),
                // const SizedBox(
                //   height: 15,
                // ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 20),
                //   child: SizedBox(
                //     width: 140,
                //     height: 30,
                //     child: RoundButton(title: "check Offers", fontSize: 12 , onPressed: () {}),
                //   ),
                // ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: _restaurants.length>150 ? 150 : _restaurants.length,
                    itemBuilder: ((context, index) {
                      var pObj = _restaurants[index] as Map? ?? {};
                      return PopularRestaurantRow(
                        pObj: pObj,
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RestaurantMenu(restaurant: pObj)));
                        },
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
