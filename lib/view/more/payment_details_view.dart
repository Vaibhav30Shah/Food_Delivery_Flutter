import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:food_delivery/common/color_extension.dart';
import 'package:food_delivery/common_widget/round_icon_button.dart';
import 'package:food_delivery/view/more/add_card_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upi_india/upi_india.dart';
import '../../common_widget/round_button.dart';
import 'my_order_view.dart';

class PaymentDetailsView extends StatefulWidget {
  final Function(Map<String, String>)? addNewCard;

  const PaymentDetailsView({super.key, this.addNewCard});

  @override
  State<PaymentDetailsView> createState() => _PaymentDetailsViewState();
}

class _PaymentDetailsViewState extends State<PaymentDetailsView> {

  Future<UpiResponse>? _transaction;
  final UpiIndia _upiIndia=UpiIndia();
  List<UpiApp>? apps;

 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCardsFromSharedPreferences();
    _upiIndia.getAllUpiApps(mandatoryTransactionId: false).then((value) {
      setState(() {
        apps = value;
      });
    }).catchError((e) {
      apps = [];
    });
    super.initState();
  }

  Future<UpiResponse> initiateTransaction(UpiApp app) async {
    return _upiIndia.startTransaction(
      app: app,
      receiverUpiId: "9099931522@pz",
      receiverName: 'Demo',
      transactionRefId: 'TestingUpiIndiaPlugin',
      transactionNote: 'Not actual. Just an example.',
      amount: 1.00,
    );
  }

  TextStyle header = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  TextStyle value = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14,
  );


  Widget displayUpiApps() {
    if (apps == null)
      return Center(child: CircularProgressIndicator());
    else if (apps!.length == 0)
      return Center(
        child: Text(
          "No apps found to handle transaction.",
          style: header,
        ),
      );
    else
      return Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Wrap(
            children: apps!.map<Widget>((UpiApp app) {
              return GestureDetector(
                onTap: () {
                  _transaction = initiateTransaction(app);
                  setState(() {});
                },
                child: Container(
                  height: 100,
                  width: 100,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.memory(
                        app.icon,
                        height: 60,
                        width: 60,
                      ),
                      Text(app.name),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      );
  }

  String _upiErrorHandler(error) {
    switch (error) {
      case UpiIndiaAppNotInstalledException:
        return 'Requested app not installed on device';
      case UpiIndiaUserCancelledException:
        return 'You cancelled the transaction';
      case UpiIndiaNullResponseException:
        return 'Requested app didn\'t return any response';
      case UpiIndiaInvalidParametersException:
        return 'Requested app cannot handle the transaction';
      default:
        return 'An Unknown error has occurred';
    }
  }

  void _checkTxnStatus(String status) {
    switch (status) {
      case UpiPaymentStatus.SUCCESS:
        print('Transaction Successful');
        break;
      case UpiPaymentStatus.SUBMITTED:
        print('Transaction Submitted');
        break;
      case UpiPaymentStatus.FAILURE:
        print('Transaction Failed');
        break;
      default:
        print('Received an Unknown transaction status');
    }
  }

  Widget displayTransactionData(title, body) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$title: ", style: header),
          Flexible(
              child: Text(
                body,
                style: value,
              )),
        ],
      ),
    );
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
    final cardNumber = cardDetails["card"]!;
    final lastFour = cardNumber.substring(cardNumber.length - 4);
    final cardKey = 'card_$lastFour';
    await prefs.setString(cardKey, jsonEncode(cardDetails));
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
    saveCardArrToSharedPreferences(cardArr);
  }

  Future<void> saveCardArrToSharedPreferences(List cardArr) async {
    final prefs = await SharedPreferences.getInstance();
    final cardListJson = cardArr.map((card) => jsonEncode(card)).toList();
    await prefs.setStringList('cards', cardListJson);
  }

  void removeCard(int index) {
    final cardToRemove = cardArr[index];
    final cardNumber = cardToRemove["card"]!;
    final lastFour = cardNumber.substring(cardNumber.length - 4);
    final cardKey = 'card_$lastFour';

    setState(() {
      cardArr.removeAt(index);
    });

    SharedPreferences.getInstance().then((prefs) {
      prefs.remove(cardKey);
    });
  }

  Future<void> getCardsFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final cardKeys = prefs.getKeys().where((key) => key.startsWith('card_')).toList();
    final cardArr = <Map<String, dynamic>>[];

    for (final cardKey in cardKeys) {
      final cardJson = prefs.getString(cardKey);
      if (cardJson != null) {
        final cardDetails = jsonDecode(cardJson);
        cardArr.add(cardDetails);
      }
    }

    setState(() {
      this.cardArr = cardArr;
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
                    // IconButton(
                    //   onPressed: () {
                    //     Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //             builder: (context) => const MyOrderView()));
                    //   },
                    //   icon: Image.asset(
                    //     "assets/img/shopping_cart.png",
                    //     width: 25,
                    //     height: 25,
                    //   ),
                    // ),
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


                    //UPI
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 35),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "UPI",
                            style: TextStyle(
                                color: TColor.primaryText,
                                fontSize: 12,
                                fontWeight: FontWeight.w700),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 100,
                          child: displayUpiApps(),
                        ),
                        SizedBox(
                          height: 100,
                          child: FutureBuilder(
                            future: _transaction,
                            builder: (BuildContext context, AsyncSnapshot<UpiResponse> snapshot) {
                              if (snapshot.connectionState == ConnectionState.done) {
                                if (snapshot.hasError) {
                                  return Center(
                                    child: Text(
                                      _upiErrorHandler(snapshot.error.runtimeType),
                                      style: header,
                                    ), // Print's text message on screen
                                  );
                                }

                                // If we have data then definitely we will have UpiResponse.
                                // It cannot be null
                                UpiResponse _upiResponse = snapshot.data!;

                                // Data in UpiResponse can be null. Check before printing
                                String txnId = _upiResponse.transactionId ?? 'N/A';
                                String resCode = _upiResponse.responseCode ?? 'N/A';
                                String txnRef = _upiResponse.transactionRefId ?? 'N/A';
                                String status = _upiResponse.status ?? 'N/A';
                                String approvalRef = _upiResponse.approvalRefNo ?? 'N/A';
                                _checkTxnStatus(status);

                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      displayTransactionData('Transaction Id', txnId),
                                      displayTransactionData('Response Code', resCode),
                                      displayTransactionData('Reference Id', txnRef),
                                      displayTransactionData('Status', status.toUpperCase()),
                                      displayTransactionData('Approval No', approvalRef),
                                    ],
                                  ),
                                );
                              } else
                                return Center(
                                  child: Text(''),
                                );
                            },
                          ),
                        )
                      ],
                    ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 35),
                        child: Divider(
                          color: TColor.secondaryText.withOpacity(0.4),
                          height: 1,
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
