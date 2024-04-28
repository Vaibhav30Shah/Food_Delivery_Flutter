import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/common/color_extension.dart';
import 'package:food_delivery/view/more/loyalty_points.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderHistory extends StatefulWidget {
  const OrderHistory({Key? key}) : super(key: key);

  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  List<Map<String, dynamic>> _orderHistory = [];
  LoyaltyPoints _loyaltyPoints = LoyaltyPoints();

  @override
  void initState() {
    super.initState();
    _loadOrderHistory();
    _loadLoyaltyPoints();
    _saveLoyaltyPoints();
  }

  Future<void> _loadOrderHistory() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = FirebaseAuth.instance.currentUser?.uid;

    final orderHistoryJson = prefs.getStringList('orderHistory_$userId') ?? [];
    setState(() {
      _orderHistory = orderHistoryJson
          .map((json) => Map<String, dynamic>.from(jsonDecode(json)))
          .toList();
    });
  }

  Future<void> _loadLoyaltyPoints() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final loyaltyPointsJson = prefs.getString('loyaltyPoints_$userId');

    if (loyaltyPointsJson != null) {
      setState(() {
        _loyaltyPoints = LoyaltyPoints.fromJson(jsonDecode(loyaltyPointsJson));
      });
    }
  }

  Future<void> _saveLoyaltyPoints() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = FirebaseAuth.instance.currentUser?.uid;
    prefs.setString('loyaltyPoints_$userId', jsonEncode(_loyaltyPoints.toJson()));
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    return Scaffold(
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(

                    children: [
                      const SizedBox(
                        height: 46,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
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
                              Text(
                                "Order History",
                                style: TextStyle(
                                    color: TColor.primaryText,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800),
                              ),
                            ]),
                      ),
                      ListView.builder(
                        physics: AlwaysScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _orderHistory.length,
                        itemBuilder: (context, index) {
                          final order = _orderHistory[index];
                          return ExpansionTile(
                            title: Text('Order Date: ${order['date']}'),
                            subtitle: Text(
                                'Total Cost: ${order['totalCost'].toString()}'),
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: order['items']?.length ?? 0,
                                itemBuilder: (context, itemIndex) {
                                  final item = order['items'][itemIndex];
                                  return ListTile(
                                    title: Text('${item['name']}'),
                                    subtitle: Text(
                                        'Price: ${item['price']} x ${item['qty']}'),
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      )
                    ]))));
  }
}
