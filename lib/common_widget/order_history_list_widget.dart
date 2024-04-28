import 'package:flutter/material.dart';

import '../common/color_extension.dart';

class OrderHistoryListWidget extends StatelessWidget {
  final String name;
  final Map mObj;
  final String price;
  final String date;
  const OrderHistoryListWidget({super.key, required this.name, required this.mObj, required this.price, required this.date,});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          Container(
            width: double.maxFinite,
            height: 200,
            decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
                  Colors.transparent,
                  Colors.transparent,
                  Colors.black
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mObj["name"],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: TColor.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(
                      height: 4,
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
                          mObj["rate"],
                          textAlign: TextAlign.center,
                          style:
                          TextStyle(color: TColor.primary, fontSize: 11),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          mObj["type"],
                          textAlign: TextAlign.center,
                          style: TextStyle(color: TColor.white, fontSize: 11),
                        ),
                        Text(
                          " . ",
                          textAlign: TextAlign.center,
                          style:
                          TextStyle(color: TColor.primary, fontSize: 11),
                        ),
                        Text(
                          mObj["food_type"],
                          textAlign: TextAlign.center,
                          style: TextStyle(color: TColor.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 22,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
