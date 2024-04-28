import 'package:flutter/material.dart';
import 'package:food_delivery/common/color_extension.dart';
import 'package:food_delivery/common_widget/add_button.dart';
import 'package:food_delivery/view/menu/restaurant_menu.dart';

class MenuFoodWidget extends StatefulWidget {
  final item;
  final List<CartItem> cartItems;
  final Function(Map<String, dynamic>) addToCart;
  final Function(Map<String, dynamic>) removeFromCart;

  const MenuFoodWidget({super.key,
    required this.item,
    required this.cartItems,
    required this.addToCart,
    required this.removeFromCart,
  });

  @override
  State<MenuFoodWidget> createState() => _MenuFoodWidgetState();
}

class _MenuFoodWidgetState extends State<MenuFoodWidget> {
  int qty=0;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            // ClipRRect(
            //   borderRadius: BorderRadius.only(
            //     topLeft: Radius.circular(16.0),
            //     bottomLeft: Radius.circular(16.0),
            //   ),
            //   child: Image.asset(
            //     "assets/img/img.png",
            //     width: 120.0,
            //     height: 120.0,
            //     fit: BoxFit.cover,
            //   ),
            // ),
            // SizedBox(width: 16.0),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.item['item'].toString(),
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      widget.item['cuisine'] == null
                          ? ' '
                          : widget.item['cuisine'],
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment
                          .spaceBetween,
                      children: [
                        Text(
                          '₹ ${widget.item['price']}',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),
                        if(widget.cartItems!=null)
                          Row(children: [
                            InkWell(
                              onTap: () {
                                qty = qty - 1;
                                widget.removeFromCart(widget.item);
                                if (qty < 0) {
                                  qty = 0;
                                }
                                setState(() {});
                              },
                              child: Container(
                                padding:
                                const EdgeInsets
                                    .symmetric(
                                    horizontal:
                                    15),
                                height: 25,
                                alignment: Alignment
                                    .center,
                                decoration: BoxDecoration(
                                    color: TColor
                                        .primary,
                                    borderRadius:
                                    BorderRadius
                                        .circular(
                                        12.5)),
                                child: Text(
                                  "-",
                                  style: TextStyle(
                                      color: TColor
                                          .white,
                                      fontSize: 14,
                                      fontWeight:
                                      FontWeight
                                          .w700),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Container(
                              padding:
                              const EdgeInsets
                                  .symmetric(
                                  horizontal:
                                  15),
                              height: 25,
                              alignment:
                              Alignment.center,
                              decoration:
                              BoxDecoration(
                                  border: Border
                                      .all(
                                    color: TColor
                                        .primary,
                                  ),
                                  borderRadius:
                                  BorderRadius
                                      .circular(
                                      12.5)),
                              child: Text(
                                qty.toString(),
                                style: TextStyle(
                                    color: TColor
                                        .primary,
                                    fontSize: 14,
                                    fontWeight:
                                    FontWeight
                                        .w500),
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            InkWell(
                              onTap: () {
                                qty = qty + 1;
                                widget.addToCart(widget.item);

                                setState(() {});
                              },
                              child: Container(
                                padding:
                                const EdgeInsets
                                    .symmetric(
                                    horizontal:
                                    15),
                                height: 25,
                                alignment: Alignment
                                    .center,
                                decoration: BoxDecoration(
                                    color: TColor
                                        .primary,
                                    borderRadius:
                                    BorderRadius
                                        .circular(
                                        12.5)),
                                child: Text(
                                  "+",
                                  style: TextStyle(
                                      color: TColor
                                          .white,
                                      fontSize: 14,
                                      fontWeight:
                                      FontWeight
                                          .w700),
                                ),
                              ),
                            ),
                          ])

                        else
                          AddButton(
                            onPressed: ()=>widget.addToCart(widget.item),
                          ),

                        //   Row(
                        //     children: [
                        //       IconButton(
                        //         icon: Icon(
                        //             Icons.remove),
                        //         onPressed: () {
                        //           removeFromCart(
                        //               cartItem);
                        //         },
                        //       ),
                        //       Text(cartItem.quantity
                        //           .toString()),
                        //       IconButton(
                        //         icon:
                        //             Icon(Icons.add),
                        //         onPressed: () {
                        //           addToCart(item);
                        //         },
                        //       ),
                        //     ],
                        //   )
                        // else
                        //   AddButton(
                        //     onPressed: () {
                        //       addToCart(item);
                        //     },
                        //   ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
