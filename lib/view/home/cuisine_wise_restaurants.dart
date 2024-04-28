import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:food_delivery/common/color_extension.dart';
import 'package:food_delivery/common_widget/popular_resutaurant_row.dart';
import 'package:food_delivery/view/menu/restaurant_menu.dart';
import 'package:http/http.dart' as http;

class CuisineWiseRestaurants extends StatefulWidget {
  final String name;

  const CuisineWiseRestaurants({super.key, required this.name});

  @override
  State<CuisineWiseRestaurants> createState() =>
      _CuisineWiseRestaurantsState();
}

class _CuisineWiseRestaurantsState extends State<CuisineWiseRestaurants> {
  List<dynamic> _restaurants = [];

  @override
  void initState(){
    super.initState();
    _fetchRestaurants();
  }

  Future<void> _fetchRestaurants() async {
    final response = await http.get(
        Uri.parse('https://food-app-cdn-new.onrender.com/api/get-restaurants-cuisine/'+widget.name));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);

      if (data['status'] == 'success') {
        setState(() {
          _restaurants = data['menus'];
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
    if(_restaurants.isEmpty){
      return Scaffold(
        body: Center(
          child: SpinKitWaveSpinner(
            color: TColor.primary,
            size: 50.0,
          ),
        ),
      );
    }
    return Scaffold(
        backgroundColor: TColor.white,
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 46,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Image.asset("assets/img/btn_back.png",
                                  width: 20, height: 20),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: Text(
                                widget.name,
                                style: TextStyle(
                                    color: TColor.primaryText,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: _restaurants.length > 150 ? 150 : _restaurants.length,
                        itemBuilder: ((context, index) {
                          var pObj = _restaurants[index];
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
                    ]))));
  }
}
