import 'package:flutter/material.dart';

import '../common/color_extension.dart';

class PopularRestaurantRow extends StatelessWidget {
  final  pObj;
  final VoidCallback onTap;
  const PopularRestaurantRow({super.key, required this.pObj, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Image.asset(
                "assets/img/img.png",
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
                      pObj["name"] ?? '',
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
                        pObj["rating"] != null
                            ? "${pObj["rating"]}/5" // Get the rating from the CSV
                            : "No ratings",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: TColor.primary, fontSize: 11),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        "(${pObj["rating_count"] ?? "0"})",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: TColor.secondaryText, fontSize: 11),
                      ),

                      const SizedBox(
                        width: 8,
                      ),

                        Text(
                          pObj["cuisine"],
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
