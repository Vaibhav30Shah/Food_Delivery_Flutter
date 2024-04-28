import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:food_delivery/common/color_extension.dart';
import 'package:food_delivery/common/loaders.dart';
import 'package:food_delivery/common_widget/round_button.dart';
import 'package:food_delivery/view/more/loyalty_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'change_address_view.dart';
import 'checkout_message_view.dart';

class CheckoutView extends StatefulWidget {
  final List? itemArr;
  const CheckoutView({super.key, this.itemArr});

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  var _razorpay = Razorpay();
  LoyaltyPoints _loyaltyPoints = LoyaltyPoints();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> orderHistory = [];
  String? promoCode;
  TextEditingController promoCodeController = TextEditingController();
  Position? _currentPosition;
  static String add = "";
  String? _userCity;
  double grandTotal = 0.0; // Initial total price
  double tipAmount = 0.0; // Initial tip amount

  void initState(){
    super.initState();
    _fetchLocation();
    _getUserLocation();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _storeOrderHistory() async {
    final orderedItems = widget.itemArr?.map((item) {
      return {
        'name': item['name'],
        'price': item['price'],
        'qty': item['qty'],
        // Add any other relevant details from the item
      };
    }).toList();

    final orderDetails = {
      'date': DateTime.now().toString(),
      'items': orderedItems,
      'totalCost': (calculateTotalPrice(widget.itemArr!) + calculateTotalPrice(widget.itemArr!) * 0.05 - calculateDiscount(calculateTotalPrice(widget.itemArr!))),
      // Add any other relevant details
    };

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = FirebaseAuth.instance.currentUser?.uid;

    // Get the existing order history list or create a new one
    List<Map<String, dynamic>> orderHistory =
        prefs.getStringList('orderHistory_$userId')?.map((json) => Map<String, dynamic>.from(jsonDecode(json))).toList() ?? [];

    // Add the new order details to the list
    orderHistory.add(orderDetails);

    // Store the updated order history list
    prefs.setStringList('orderHistory_$userId', orderHistory.map((order) => jsonEncode(order)).toList());

    final loyaltyPoints = await _loadLoyaltyPoints();

    loyaltyPoints.orderCount++;
    if (loyaltyPoints.orderCount % 5 == 0) {
      loyaltyPoints.points += 5;
    }

    await _saveLoyaltyPoints(loyaltyPoints);
  }

  Future<LoyaltyPoints> _loadLoyaltyPoints() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final loyaltyPointsJson = prefs.getString('loyaltyPoints_$userId');

    if (loyaltyPointsJson != null) {
      return LoyaltyPoints.fromJson(jsonDecode(loyaltyPointsJson));
    } else {
      return LoyaltyPoints();
    }
  }

  Future<void> _saveLoyaltyPoints(LoyaltyPoints loyaltyPoints) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = FirebaseAuth.instance.currentUser?.uid;
    prefs.setString('loyaltyPoints_$userId', jsonEncode(loyaltyPoints.toJson()));
  }

  Future<void> _getUserLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        String city = placemark.locality ?? '';
        setState(() {
          _userCity = city;
        });
      }
    } catch (e) {
      print('Error getting user location: $e');
    }
  }

  Future<Position> getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      // if (permission == LocationPermission.denied) {
      //   return ;
      // }
    }
    return await Geolocator.getCurrentPosition();
  }


  double calculateSubTotalPrice(List itemArr) {
    double totalPrice = 0.0;
    for (var item in itemArr) {
      final price = double.parse(item['price'].toString());
      final qty = int.parse(item['qty'].toString());
      totalPrice += price * qty;
    }
    return totalPrice;
  }

  bool isValidPromoCode(String code) {
    return code.toUpperCase() == 'FIRST10';
  }

  double calculateTotalPrice(List itemArr) {
    double totalPrice = calculateSubTotalPrice(itemArr);
    totalPrice += 20; // Delivery cost
    grandTotal=totalPrice;
    return grandTotal;
  }

  double calculateDiscount(double totalPrice) {
    if (promoCode?.toUpperCase().trim()=="FIRST10") {
      return totalPrice * 0.1; // 10% discount
    }
    return 0;
  }

  double calculateTotalPriceWithTip() {
    double totalPrice = calculateTotalPrice(widget.itemArr!) + calculateTotalPrice(widget.itemArr!) * 0.05 - calculateDiscount(calculateTotalPrice(widget.itemArr!));
    return totalPrice + tipAmount;
  }
  //
  // List paymentArr = [
  //   {"name": "Cash on delivery", "icon": "assets/img/cash.png"},
  //   {"name": "**** **** **** 2187", "icon": "assets/img/visa_icon.png"},
  //   {"name": "test@gmail.com", "icon": "assets/img/paypal.png"},
  // ];

  void _fetchLocation() async {
    Position position = await getCurrentLocation();
    final coordinates = new Coordinates(position.latitude, position.longitude);
    var address =
    await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = address.first;
    add = first.addressLine.toString();
    print(add);
    setState(() {
      _currentPosition = position;
    });
    print(_currentPosition!.latitude + _currentPosition!.longitude);
  }

  int selectMethod = -1;

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (context) {
          return const CheckoutMessageView();
        });
    _storeOrderHistory();
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails

  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet is selected
  }

  void addTipToTotal(double amount) {
    setState(() {
      tipAmount = amount;
    });
  }

  void showCustomTipDialog() {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController customTipController = TextEditingController();
        return AlertDialog(
          title: Text('Enter Custom Tip'),
          content: TextField(
            controller: customTipController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Enter tip amount',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                double customTip = double.tryParse(customTipController.text) ?? 0.0;
                addTipToTotal(customTip);
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose(){
    _razorpay.clear(); // Removes all listeners
    super.dispose();
  }

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
                        "Checkout",
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Delivery Address",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(color: TColor.secondaryText, fontSize: 12),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: add.toString()=="" ? Text("Loading your location"):Text(
                            add.toString(),
                            style: TextStyle(
                                color: TColor.primaryText,
                                fontSize: 15,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ChangeAddressView()),
                            );
                          },
                          child: Text(
                            "Change",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: TColor.primary,
                                fontSize: 13,
                                fontWeight: FontWeight.w700),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(color: TColor.textfield),
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Tips for Kitchen Staff",
                        style: TextStyle(
                            color: TColor.primaryText,
                            fontSize: 15,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () => addTipToTotal(20),
                          child: Text('₹20'),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => addTipToTotal(30),
                          child: Text('₹30'),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.orange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => addTipToTotal(50),
                          child: Text('₹50'),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => showCustomTipDialog(),
                          child: Text('Other'),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Text(
                    //       "Payment method",
                    //       textAlign: TextAlign.center,
                    //       style: TextStyle(
                    //           color: TColor.secondaryText,
                    //           fontSize: 13,
                    //           fontWeight: FontWeight.w500),
                    //     ),
                    //     TextButton.icon(
                    //       onPressed: () {},
                    //       icon: Icon(Icons.add, color: TColor.primary),
                    //       label: Text(
                    //         "RazorPay",
                    //         style: TextStyle(
                    //             color: TColor.primary,
                    //             fontSize: 13,
                    //             fontWeight: FontWeight.w700),
                    //       ),
                    //     )
                    //   ],
                    // ),
                    // ListView.builder(
                    //     physics: const NeverScrollableScrollPhysics(),
                    //     padding: EdgeInsets.zero,
                    //     shrinkWrap: true,
                    //     itemCount: paymentArr.length,
                    //     itemBuilder: (context, index) {
                    //       var pObj = paymentArr[index] as Map? ?? {};
                    //       return Container(
                    //         margin: const EdgeInsets.symmetric(vertical: 8.0),
                    //         padding: const EdgeInsets.symmetric(
                    //             vertical: 8.0, horizontal: 15.0),
                    //         decoration: BoxDecoration(
                    //             color: TColor.textfield,
                    //             borderRadius: BorderRadius.circular(5),
                    //             border: Border.all(
                    //                 color:
                    //                     TColor.secondaryText.withOpacity(0.2))),
                    //         child: Row(
                    //           children: [
                    //             Image.asset(pObj["icon"].toString(),
                    //                 width: 50, height: 20, fit: BoxFit.contain),
                    //             // const SizedBox(width: 8),
                    //             Expanded(
                    //               child: Text(
                    //                 pObj["name"],
                    //                 style: TextStyle(
                    //                     color: TColor.primaryText,
                    //                     fontSize: 12,
                    //                     fontWeight: FontWeight.w500),
                    //               ),
                    //             ),
                    //
                    //             InkWell(
                    //               onTap: () {
                    //                 setState(() {
                    //                   selectMethod = index;
                    //                 });
                    //               },
                    //               child: Icon(
                    //                 selectMethod == index
                    //                     ? Icons.radio_button_on
                    //                     : Icons.radio_button_off,
                    //                 color: TColor.primary,
                    //                 size: 15,
                    //               ),
                    //             )
                    //           ],
                    //         ),
                    //       );
                    //     })
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(color: TColor.textfield),
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 15,),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: promoCodeController,
                            decoration: InputDecoration(
                              hintText: 'Enter promo code',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateColor.resolveWith((states) => (TColor.primary))
                          ),
                          onPressed: () {
                            String enteredCode = promoCodeController.text.trim();
                            if (isValidPromoCode(enteredCode)) {
                              setState(() {
                                promoCode = enteredCode;
                              });
                            } else {
                              setState(() {
                                promoCode = null; // Reset the promoCode
                              });
                              // Show an error message or handle invalid promo code
                              TLoaders.errorSnackBar(title: "Invalid Promo Code", message: "Enter valid promo code");
                            }
                          },
                          child: Text('Apply'),
                        ),
                      ],
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
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          "₹ ${calculateSubTotalPrice(widget.itemArr!).toStringAsFixed(0)}",
                          style: TextStyle(
                              color: TColor.primaryText,
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
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          "₹ 20",
                          style: TextStyle(
                              color: TColor.primaryText,
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
                          "Discount",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: TColor.primaryText,
                              fontSize: 13,
                              fontWeight: FontWeight.w500),
                        ),
                        isValidPromoCode(promoCodeController.text.toString())?Text(
                          "₹ ${calculateDiscount(calculateTotalPrice(widget.itemArr!)).toStringAsFixed(2)}",
                          style: TextStyle(
                              color: TColor.primaryText,
                              fontSize: 13,
                              fontWeight: FontWeight.w700),
                        ):
                        Text(
                          "₹ 0",
                          style: TextStyle(
                              color: TColor.primaryText,
                              fontSize: 13,
                              fontWeight: FontWeight.w700),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    _buildLoyaltyPointsSection(),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Tips for Kitchen Staff",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: TColor.primaryText,
                              fontSize: 13,
                              fontWeight: FontWeight.w500),
                        ),
                        tipAmount>0?Text(
                          "₹ ${tipAmount}",
                          style: TextStyle(
                              color: TColor.primaryText,
                              fontSize: 13,
                              fontWeight: FontWeight.w700),
                        ):
                        Text(
                          "₹ 0",
                          style: TextStyle(
                              color: TColor.primaryText,
                              fontSize: 13,
                              fontWeight: FontWeight.w700),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "SGST (2.5%)",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: TColor.primaryText,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "₹ ${(calculateTotalPrice(widget.itemArr!) * 0.025).toStringAsFixed(2)}",
                          style: TextStyle(
                            color: TColor.primaryText,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
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
                          "CGST (2.5%)",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: TColor.primaryText,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "₹ ${(calculateTotalPrice(widget.itemArr!) * 0.025).toStringAsFixed(2)}",
                          style: TextStyle(
                            color: TColor.primaryText,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
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
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          // "₹ ${(calculateTotalPrice(widget.itemArr!) + calculateTotalPrice(widget.itemArr!) * 0.05 - calculateDiscount(calculateTotalPrice(widget.itemArr!))).toStringAsFixed(2)}",
                         "${calculateTotalPriceWithTip().toStringAsFixed(2)}",
                          style: TextStyle(
                              color: TColor.primaryText,
                              fontSize: 15,
                              fontWeight: FontWeight.w700),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(color: TColor.textfield),
                height: 8,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                child: RoundButton(
                    title: "Send Order",
                    onPressed: () {
                      var options = {
                        'key': 'rzp_test_wmA9hj8JWjZQbD',
                        'amount': ((calculateTotalPrice(widget.itemArr!) + calculateTotalPrice(widget.itemArr!) * 0.05 - calculateDiscount(calculateTotalPrice(widget.itemArr!))) * 100), //in the smallest currency sub-unit.
                        'name': 'Pet Pujari',
                        'order_id': 'order_EMBFqjDHEEn80l', // Generate order_id using Orders API
                        'description': '${widget.itemArr}',
                        'timeout': 300, // in seconds
                        // 'prefill': {
                        //   'contact': '9000090000',
                        //   'email': 'gaurav.kumar@example.com'
                        // }
                      };
                      print("Amount:::: ${options['amount']}");
                      _razorpay.open(options);
                      // showModalBottomSheet(
                      //     context: context,
                      //     backgroundColor: Colors.transparent,
                      //     isScrollControlled: true,
                      //     builder: (context) {
                      //       return const CheckoutMessageView();
                      //     });
                      // _storeOrderHistory();
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoyaltyPointsSection() {
    if (_loyaltyPoints.points >= 50) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'You have ${_loyaltyPoints.points} loyalty points',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          ElevatedButton(
            style: ButtonStyle(backgroundColor: MaterialStateColor.resolveWith((states) => TColor.primary)),
            onPressed: () {
              setState(() {
                _loyaltyPoints.points -= 50;
                _saveLoyaltyPoints(_loyaltyPoints);
                // Apply the discount to the total cost
              });
            },
            child: Text('Redeem 50 points for ₹50 discount'),
          ),
        ],
      );
    } else {
      return Text(
        'You have ${_loyaltyPoints.points} loyalty points',
        style: TextStyle(fontSize: 13),
      );
    }
  }

}
