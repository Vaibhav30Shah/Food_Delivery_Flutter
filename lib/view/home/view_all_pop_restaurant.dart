import 'package:flutter/material.dart';
import 'package:food_delivery/common/color_extension.dart';
import 'package:food_delivery/common_widget/popular_resutaurant_row.dart';
import 'package:food_delivery/view/menu/restaurant_menu.dart';

class ViewAllPopularRestaurants extends StatefulWidget {
  final List<dynamic> data;

  const ViewAllPopularRestaurants({super.key,required this.data});

  @override
  State<ViewAllPopularRestaurants> createState() =>
      _ViewAllPopularRestaurantsState();
}

class _ViewAllPopularRestaurantsState extends State<ViewAllPopularRestaurants> {

  @override
  Widget build(BuildContext context) {
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
                                "Restaurants",
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
                        itemCount: 150,
                        itemBuilder: ((context, index) {
                          var pObj = widget.data[index];
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
