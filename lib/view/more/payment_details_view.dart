import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food_delivery/common/color_extension.dart';
import 'package:food_delivery/common_widget/round_icon_button.dart';
import 'package:food_delivery/view/more/add_card_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common_widget/round_button.dart';
import 'my_order_view.dart';

class PaymentDetailsView extends StatefulWidget {
  final Function(Map<String, String>)? addNewCard;

  const PaymentDetailsView({super.key, this.addNewCard});

  @override
  State<PaymentDetailsView> createState() => _PaymentDetailsViewState();
}

class _PaymentDetailsViewState extends State<PaymentDetailsView> {
 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCardsFromSharedPreferences();
  }

  List cardArr = [
    {
      "icon": "assets/img/visa_icon.png",
      "card": "**** **** **** 2187",
      "lastFour": "2187"
    }
  ];

  Future<void> saveCardToSharedPreferences(Map<String, String> cardDetails) async {
    final prefs = await SharedPreferences.getInstance();
    final cardList = prefs.getStringList('cards') ?? [];
    cardList.add(jsonEncode(cardDetails));
    await prefs.setStringList('cards', cardList);
  }

  void addNewCard(Map<String, String> cardDetails) {
    setState(() {
      String cardNumber = cardDetails["card"]!;
      String lastFour = cardNumber.substring(cardNumber.length - 4);
      cardArr.add({
        "icon": cardDetails["icon"],
        "card": cardNumber,
        "lastFour": lastFour
      });
    });
    widget.addNewCard!(cardDetails);
    saveCardToSharedPreferences(cardDetails);
  }

  void removeCard(int index) {
    setState(() {
      cardArr.removeAt(index);
    });
  }

  Future<void> getCardsFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final cardList = prefs.getStringList('cards') ?? [];
    setState(() {
      cardArr = cardList.map((card) => jsonDecode(card)).toList().cast<Map<String, String>>();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        "Payment Details",
                        style: TextStyle(
                            color: TColor.primaryText,
                            fontSize: 20,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MyOrderView()));
                      },
                      icon: Image.asset(
                        "assets/img/shopping_cart.png",
                        width: 25,
                        height: 25,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                child: Text(
                  "Customize your payment method",
                  style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 16,
                      fontWeight: FontWeight.w700),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Divider(
                  color: TColor.secondaryText.withOpacity(0.4),
                  height: 1,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                decoration: BoxDecoration(
                    color: TColor.textfield,
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black26,
                          blurRadius: 15,
                          offset: Offset(0, 9))
                    ]),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 35),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Cash/Card On Delivery",
                            style: TextStyle(
                                color: TColor.primaryText,
                                fontSize: 12,
                                fontWeight: FontWeight.w700),
                          ),
                          Image.asset(
                            "assets/img/check.png",
                            width: 20,
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 35),
                      child: Divider(
                        color: TColor.secondaryText.withOpacity(0.4),
                        height: 1,
                      ),
                    ),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: cardArr.length,
                      itemBuilder: ((context, index) {
                        var cObj = cardArr[index] as Map? ?? {};
                        return Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 35),
                          child: Row(
                            children: [
                              Image.asset(
                                cObj["icon"].toString(),
                                width: 50,
                                height: 35,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: Text(
                                  "**** **** **** ${cObj["lastFour"].toString()}",
                                  style: TextStyle(
                                    color: TColor.secondaryText,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 100,
                                height: 28,
                                child: RoundButton(
                                  title: 'Delete Card',
                                  fontSize: 12,
                                  onPressed: () {
                                    removeCard(index);
                                  },
                                  type: RoundButtonType.textPrimary,
                                ),
                              )
                            ],
                          ),
                        );
                      }),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 35),
                      child: Divider(
                        color: TColor.secondaryText.withOpacity(0.4),
                        height: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 35),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Other Methods",
                            style: TextStyle(
                                color: TColor.primaryText,
                                fontSize: 12,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 35,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: RoundIconButton(
                    title: "Add Another Credit/Debit Card",
                    icon: "assets/img/add.png",
                    color: TColor.primary,
                    fontSize: 16,
                    onPressed: () {
                      showModalBottomSheet(
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (context) {
                            return const AddCardView();
                          }).then((newCardDetails) {
                        if (newCardDetails != null) {
                          setState(() {
                            cardArr.add(newCardDetails);
                          });
                        }
                      });
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => const AddCardView() ));
                    }),
              ),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
