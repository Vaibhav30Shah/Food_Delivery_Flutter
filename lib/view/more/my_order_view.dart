import 'package:flutter/material.dart';
import 'package:food_delivery/common/color_extension.dart';
import 'package:food_delivery/common_widget/round_button.dart';
import 'package:food_delivery/view/more/add_notes_modal.dart';

import 'checkout_view.dart';

class MyOrderView extends StatefulWidget {
  final List? itemArr;
  final restArr;
  const MyOrderView({super.key, this.itemArr, this.restArr});

  @override
  State<MyOrderView> createState() => _MyOrderViewState();
}

class _MyOrderViewState extends State<MyOrderView> {
  String? deliveryInstruction;

  final Map<String, String> cuisineImageMap = {
    'Indian': "assets/img/cuisines/indian_chinese.png",
    'Gujarati':'assets/img/cuisines/gujarati.jpg',
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

    // Add more key-value pairs for other cuisines
  };

  double calculateSubTotalPrice(List itemArr) {
    double totalPrice = 0.0;
    for (var item in itemArr) {
      final price = double.parse(item['price'].toString());
      final qty = int.parse(item['qty'].toString());
      totalPrice += price * qty;
    }
    return totalPrice;
  }

  double calculateTotalPrice(List itemArr) {
    double totalPrice = 0.0;
    for (var item in itemArr) {
      final price = double.parse(item['price'].toString());
      final qty = int.parse(item['qty'].toString());
      totalPrice += price * qty;
    }
    widget.itemArr!.isEmpty?totalPrice=0:totalPrice+=20;
    return totalPrice;
  }

  @override
  Widget build(BuildContext context) {
    final String cuisineString = widget.restArr['cuisine'];
    final List<String> cuisines = cuisineString.split(',').map((cuisine) => cuisine.trim()).toList();

    String imagePath = 'assets/img/logo.png';
    for (final cuisine in cuisines) {
      if (cuisineImageMap.containsKey(cuisine)) {
        imagePath = cuisineImageMap[cuisine]!;
        break;
      }
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
                        "My Order",
                        style: TextStyle(
                            color: TColor.primaryText,
                            fontSize: 20,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                child: Row(
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.asset(
                          imagePath,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        )),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${widget.restArr['name']}",
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
                                "${widget.restArr['rating']}",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: TColor.primary, fontSize: 12),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                "(${widget.restArr['rating_count']})",
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
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "${widget.restArr['cuisine']}",
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
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(
                                "assets/img/location-pin.png",
                                width: 13,
                                height: 13,
                                fit: BoxFit.contain,
                                // alignment: Alignment.topLeft,
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Expanded(
                                child: Text(
                                  "${widget.restArr['address']}",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: TColor.secondaryText,
                                      fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(color: TColor.textfield),
                child: ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: widget.itemArr!.length,
                  separatorBuilder: ((context, index) => Divider(
                        indent: 25,
                        endIndent: 25,
                        color: TColor.secondaryText.withOpacity(0.5),
                        height: 1,
                      )),
                  itemBuilder: ((context, index) {
                    var cObj = widget.itemArr?[index] as Map? ?? {};
                    final price = double.parse(cObj['price'].toString());
                    final qty = int.parse(cObj['qty'].toString());
                    final itemTotal = price * qty;
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 25),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              "${cObj["name"].toString()} x${cObj["qty"].toString()}",
                              style: TextStyle(
                                  color: TColor.primaryText,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Text(
                            "₹ ${itemTotal.toStringAsFixed(0)}",
                            style: TextStyle(
                                color: TColor.primaryText,
                                fontSize: 13,
                                fontWeight: FontWeight.w700),
                          )
                        ],
                      ),
                    );
                  }),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Delivery Instructions",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: TColor.primaryText,
                              fontSize: 13,
                              fontWeight: FontWeight.w700),
                        ),
                        TextButton.icon(
                          onPressed: () {
                            showModalBottomSheet(
                              showDragHandle: true,
                              shape: BeveledRectangleBorder(),
                              context: context,
                              // isScrollControlled: true,
                              builder: (context) => AddNotesModal(
                                onSave: (instructions) {
                                  setState(() {
                                    deliveryInstruction = instructions;
                                  });
                                },
                              ),
                            );
                          },
                          icon: Icon(Icons.add, color: TColor.primary),
                          label: Text(
                            "Add Notes",
                            style: TextStyle(
                                color: TColor.primary,
                                fontSize: 13,
                                fontWeight: FontWeight.w500),
                          ),
                        )
                      ],
                    ),
                    if (deliveryInstruction != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          'Delivery Instructions: $deliveryInstruction',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    Divider(
                      color: TColor.secondaryText.withOpacity(0.5),
                      height: 1,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Sub Total",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: TColor.primaryText,
                              fontSize: 13,
                              fontWeight: FontWeight.w700),
                        ),
                        Text(
                          "₹ ${calculateSubTotalPrice(widget.itemArr!).toStringAsFixed(0)}",
                          style: TextStyle(
                              color: TColor.primary,
                              fontSize: 13,
                              fontWeight: FontWeight.w700),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Delivery Cost",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: TColor.primaryText,
                              fontSize: 13,
                              fontWeight: FontWeight.w700),
                        ),
                        Text(
                          widget.itemArr!.isEmpty?"0":"₹ 20",
                          style: TextStyle(
                              color: TColor.primary,
                              fontSize: 13,
                              fontWeight: FontWeight.w700),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Divider(
                      color: TColor.secondaryText.withOpacity(0.5),
                      height: 1,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: TColor.primaryText,
                              fontSize: 13,
                              fontWeight: FontWeight.w700),
                        ),
                        Text(
                          "₹ ${calculateTotalPrice(widget.itemArr!).toStringAsFixed(2)}",
                          style: TextStyle(
                              color: TColor.primary,
                              fontSize: 22,
                              fontWeight: FontWeight.w700),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    RoundButton(
                        title: "Checkout",
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CheckoutView(itemArr: widget.itemArr,),
                            ),
                          );
                        }),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
