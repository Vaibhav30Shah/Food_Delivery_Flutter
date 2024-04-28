import 'package:flutter/material.dart';

import '../common/color_extension.dart';

class MostPopularCell extends StatefulWidget {
  final Map mObj;
  final VoidCallback onTap;
  const MostPopularCell({super.key, required this.mObj, required this.onTap});

  @override
  State<MostPopularCell> createState() => _MostPopularCellState();
}

class _MostPopularCellState extends State<MostPopularCell> {
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
    'Healthy Food':'assets/img/cuisines/healthy.jpg',
    'Juices':'assets/img/cuisines/juice.jpeg',
    'Italian':'assets/img/cuisines/italian.jpg',
    // Add more key-value pairs for other cuisines
  };

  @override
  Widget build(BuildContext context) {
    final String cuisineString = widget.mObj['cuisine'];
    final List<String> cuisines = cuisineString.split(',').map((cuisine) => cuisine.trim()).toList();

    String imagePath = 'assets/img/logo.png';
    for (final cuisine in cuisines) {
      if (cuisineImageMap.containsKey(cuisine)) {
        imagePath = cuisineImageMap[cuisine]!;
        break;
      }
    }
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: InkWell(
          onTap: widget.onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  imagePath,
                  width: 220,
                  height: 130,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                widget.mObj['name'].toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: TColor.primaryText,
                    fontSize: 18,
                    fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 4,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    widget.mObj["cuisine"],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: TColor.secondaryText,
                        fontSize: 12),
                  ),

                  Text(
                    " . ",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: TColor.primary, fontSize: 12),
                  ),

                  Text(
                    "₹${widget.mObj["cost"].toString()}",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: TColor.secondaryText, fontSize: 12),
                  ),

                  const SizedBox(
                    width: 8,
                  ),

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
                    widget.mObj["rating"].toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: TColor.primary, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
  }
}
