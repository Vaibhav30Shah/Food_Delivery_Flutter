import 'package:flutter/material.dart';
import 'package:food_delivery/common/color_extension.dart';

class RestaurantDetails extends StatelessWidget {
  final restaurant;

  const RestaurantDetails({Key? key, required this.restaurant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              restaurant['name'],
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/img/rate.png",
                  width: 10,
                  height: 10,
                  fit: BoxFit.cover,
                ),
                const SizedBox(
                  width: 4,
                ),
                Text(
                  "${restaurant['rating']}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: TColor.primary, fontSize: 12),
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  "(${restaurant['rating_count']})",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: TColor.secondaryText, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(
              height: 4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${restaurant['cuisine']}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: TColor.secondaryText, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(
              height: 4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/img/location-pin.png",
                  width: 13,
                  height: 13,
                  fit: BoxFit.contain,
                ),
                const SizedBox(
                  width: 4,
                ),
                Text(
                  "${restaurant['city']}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: TColor.secondaryText,
                      fontSize: 12),
                ),
              ],
            ),
            const SizedBox(
              width: 8,
            ),
          Divider()
          ],
        ),
      ),
    );
  }
}