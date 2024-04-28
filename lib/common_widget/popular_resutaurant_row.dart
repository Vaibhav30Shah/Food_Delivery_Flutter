import 'package:flutter/material.dart';

import '../common/color_extension.dart';

class PopularRestaurantRow extends StatefulWidget {
  final  pObj;
  final VoidCallback onTap;
  const PopularRestaurantRow({super.key, required this.pObj, required this.onTap});

  @override
  State<PopularRestaurantRow> createState() => _PopularRestaurantRowState();
}

class _PopularRestaurantRowState extends State<PopularRestaurantRow> {
  final Map<String, String> cuisineImageMap = {
    'Indian': "assets/img/cuisines/indian_chinese.png",
    'Gujarati': "assets/img/cuisines/gujarati.jpg",
    'Fast Food': 'assets/img/cuisines/fastfood.jpg',
    'North Indian':'assets/img/cuisines/northindian.jpg',
    'Combo':'assets/img/cuisines/combo.jpg',
    'Biryani':'assets/img/cuisines/biryani.jpg',
    'Waffle':'assets/img/cuisines/waffles.jpg',
    'Chinese':'assets/img/cuisines/chinese.jpg',
    'Thai':'assets/img/cuisines/thai.jpg',
    'Pizzas':'assets/img/cuisines/pizza.jpg',
    'Chaat':'assets/img/cuisines/chaat.jpg',
    'Street Food':'assets/img/cuisines/streetfood.jpg',
    'Beverages':'assets/img/cuisines/beverages.jpg',
    'Mexican':'assets/img/cuisines/mexican.jpg',
    'Snacks':'assets/img/cuisines/snacks.jpg',
    'Pastas':'assets/img/cuisines/pasta.jpg',
    'Thalis':'assets/img/cuisines/thali.jpg',
    'South Indian':'assets/img/south_indian.png',
    'Bakery':'assets/img/cuisines/desserts.jpg',
    'Desserts':'assets/img/cuisines/desserts.jpg',
    'Ice Cream':'assets/img/cuisines/desserts.jpg',
    'Rajasthani':'assets/img/cuisines/rajasthani.jpg',
    'Sweets':'assets/img/cuisines/sweets.jpg',
    'Continental':'assets/img/cuisines/continental.jpg',
    'Healthy':'assets/img/cuisines/healthy.jpg',
    'Juices':'assets/img/cuisines/juice.jpeg',
    'Italian':'assets/img/cuisines/italian.jpg',
    // Add more key-value pairs for other cuisines
  };

  @override
  Widget build(BuildContext context) {
    final String cuisineString = widget.pObj['cuisine'];
    final List<String> cuisines = cuisineString.split(',').map((cuisine) => cuisine.trim()).toList();

    String imagePath = 'assets/img/logo.png';
    for (final cuisine in cuisines) {
      if (cuisineImageMap.containsKey(cuisine)) {
        imagePath = cuisineImageMap[cuisine]!;
        break;
      }
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: widget.onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Image.asset(
                imagePath,
                width: double.maxFinite,
                height: 200,
                fit: BoxFit.cover,
              ),
              const SizedBox(
              width: 8,
            ),

             const SizedBox(
              height: 12,
            ),

             Padding(
               padding: const EdgeInsets.symmetric(horizontal: 20),
               child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.pObj["name"] ?? '',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: TColor.primaryText,
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
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
                        widget.pObj["rating"] != null
                            ? "${widget.pObj["rating"]}/5" // Get the rating from the CSV
                            : "No ratings",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: TColor.primary, fontSize: 11),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        "(${widget.pObj["rating_count"] ?? "0"})",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: TColor.secondaryText, fontSize: 11),
                      ),

                      const SizedBox(
                        width: 8,
                      ),

                        Text(
                          widget.pObj["cuisine"],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: TColor.secondaryText, fontSize: 11),
                        ),
                        Text(
                          " . ",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: TColor.primary, fontSize: 11),
                        ),
                        // Text(
                        //   pObj["food_type"],
                        //   textAlign: TextAlign.center,
                        //   style: TextStyle(
                        //       color: TColor.secondaryText, fontSize: 12),
                        // ),
                      ],
                    ),

                  ],
                ),
             ),

          ],
        ),
      ),
    );
  }
}
