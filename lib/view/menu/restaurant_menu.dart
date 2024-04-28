import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:food_delivery/common_widget/menu_food_widget.dart';
import 'package:http/http.dart' as http;
import 'package:food_delivery/common/color_extension.dart';
import 'package:food_delivery/common_widget/add_button.dart';
import 'package:food_delivery/view/menu/restaurant_details.dart';
import 'package:get/get.dart';
import 'package:food_delivery/view/more/my_order_view.dart';

class RestaurantMenu extends StatefulWidget {
  final restaurant;
  final List<CartItem> cartItems;

  const RestaurantMenu({Key? key, this.restaurant, this.cartItems = const []})
      : super(key: key);

  @override
  _RestaurantMenuState createState() => _RestaurantMenuState();
}

class _RestaurantMenuState extends State<RestaurantMenu> {
  late List<CartItem> _cartItems;
  List menuItems = [];

  void navigateToMyOrderView(MenuItem item) {
    Get.to(() => MyOrderView(
          itemArr: [
            ..._cartItems.map((cartItem) => {
                  "name": cartItem.item.name,
                  "qty": cartItem.quantity.toString(),
                  "price": cartItem.item.price,
                }),
          ],
        ));
  }

  @override
  void initState() {
    super.initState();
    _cartItems = widget.cartItems.toList();
    // fetchMenu();
    fetchMenuItems1();
    // fetchMenuItems();
  }

  Future<void> fetchMenuItems1() async {
    final restaurantId = widget.restaurant['id'];
    print(restaurantId);

    try {
      final mr = await http.get(Uri.parse(
          'https://food-app-cdn.onrender.com/api/get-menus2/' +
              restaurantId.toString()));
      if (mr.statusCode == 200) {
        final md = jsonDecode(mr.body);
        if (md['status'] == 'success') {

          print('Menu data: ${md['menus']}');

          final menus=md['menus'];

          // Fetch menu data
          final menuResponse = await http.get(Uri.parse(
              'https://food-app-cdn.onrender.com/api/get-foods2/' +
                  restaurantId.toString()));
          if (menuResponse.statusCode == 200) {
            final menuData = jsonDecode(menuResponse.body);
            if (menuData['status'] == 'success') {
              print('Menu data: ${menuData['foods']}'); // Print the menu data

              final foods = menuData['foods'];

              final uniqueFoodItems = <Map<String, dynamic>>{};

              menuItems = menus.map((menu) {
                final foodItem = foods.firstWhere(
                      (food) => food['f_id'].toString() == menu['f_id'].toString(),
                  orElse: () => null,
                );

                print("Food item: $foodItem");

                if (foodItem != null &&
                    !uniqueFoodItems.contains(foodItem)) {
                  uniqueFoodItems.add(foodItem);
                  return {
                    'cuisine': menu['cuisine'],
                    'item': foodItem != null ? foodItem['item'] : '',
                    'veg_or_non_veg':
                    foodItem != null ? foodItem['veg_or_non_veg'] : '',
                    'price': menu['price'],
                  };
                }
              }).whereType<Map<String, dynamic>>().toList();

              // menuItems.addAll(foods.map((foodItem) {
              //   return {
              //     'cuisine': md['cuisine'],
              //     'item': foodItem['item'],
              //     'veg_or_non_veg': foodItem['veg_or_non_veg'],
              //     'price': md['price'],
              //   };
              // }).toList());

              if (mounted) {
                setState(() {});
              }

              // Fetch food data
              // final foodResponse = await http.get(
              //     Uri.parse('https://food-app-cdn.onrender.com/api/get-foods'));
              //
              // if (foodResponse.statusCode == 200) {
              //   final foodData = jsonDecode(foodResponse.body);
              //   if (foodData['status'] == 'success') {
              //     final foods = foodData['foods'];
              //     final menus = menuData['menus'];
              //
              //     print('Food data: $foods'); // Print the food data
              //
              //     // Combine menu and food data for the selected restaurant
              //     menuItems = menus.map((menu) {
              //       final foodItem = foods.firstWhere(
              //         (food) => food['f_id'].toString() == menu['f_id'].toString(),
              //         orElse: () => null,
              //       );
              //
              //       print("Food item: $foodItem");
              //
              //       return {
              //         'cuisine': menu['cuisine'],
              //         'item': foodItem != null ? foodItem['item'] : '',
              //         'veg_or_non_veg':
              //             foodItem != null ? foodItem['veg_or_non_veg'] : '',
              //         'price': menu['price'],
              //       };
              //     }).toList();

              //     print('Menu items: $menuItems'); // Print the menu items
              //
              //     if (mounted) {
              //       setState(() {});
              //     }
              //   } else {
              //     print('Error fetching food data: ${foodData['message']}');
              //   }
              // } else {
              //   print('Failed to fetch food data');
              // }
            } else {
              print('Error fetching food data: ${menuData['message']}');
            }
          } else {}
        }
      } else {
        print('Failed to fetch menu data');
      }
    } catch (e) {
      print('Error fetching menu items: $e');
    }
  }

//   Future<void> fetchMenu() async {
//     final restaurantId = widget.restaurant['id'];
//     print("Rest id $restaurantId");
//
//     // Fetch menu data
//     final menuResponse = await http
//         .get(Uri.parse('https://food-app-cdn-new.onrender.com/api/get-menus'));
//
//     print("Menu response: $menuResponse");
//
//     if (menuResponse.statusCode == 200) {
//       final menuData = jsonDecode(menuResponse.body);
//       print("Menu Data: $menuData");
//
//       if (menuData['status'] == 'success') {
//         final restaurantMenus = menuData['menus']
//             .where((menu) => menu['id'] == restaurantId)
//             .toList();
//
//         // Fetch food data
//         final foodResponse = await http.get(
//             Uri.parse('https://food-app-cdn-new.onrender.com/api/get-foods'));
//         print("Food response: $foodResponse");
//
//         if (foodResponse.statusCode == 200) {
//           final foodData = jsonDecode(foodResponse.body);
//           if (foodData['status'] == 'success') {
//             final foods = foodData['foods'];
//
//             print("Food Data: $foodData");
//
//             // Combine menu and food data for the selected restaurant
//             menuItems = restaurantMenus.map((menu) {
//               final foodItem =
//                   foods.firstWhere((food) => food['f_id'] == menu['f_id']);
//               print("Food item $foodItem");
//               return {
//                 'cuisine': menu['cuisine'],
//                 'item': foodItem != null ? foodItem['item'] : '',
//                 'veg_or_non_veg':
//                     foodItem != null ? foodItem['veg_or_non_veg'] : '',
//                 'price': menu['price'],
//               };
//             }).toList();
//
//             print("Menu Items: $menuItems");
//             setState(() {});
//           } else {
//             print('Error fetching food data: ${foodData['message']}');
//           }
//         } else {
//           print('Failed to fetch food data');
//         }
//       } else {
//         print('Error fetching menu data: ${menuData['message']}');
//       }
//     } else {
//       print('Failed to fetch menu data');
//     }
//   }
//
//   Future<void> fetchMenuItems() async {
//     final String restaurantId = widget.restaurant['id'].toString();
//
//     final menuData = await loadMenuData(restaurantId);
//
//     menuItems = menuData.map((menuItem) {
//       return MenuItem(
//           name: menuItem['item'] ?? '',
//           vegOrNonVeg: menuItem['veg_or_non_veg'] ?? '',
//           price: menuItem['price'] ?? 0.0,
//           cuisine: menuItem['cuisine'] ?? '');
//     }).toList();
//
//     setState(() {});
//   }
//
//   Future<List<Map<String, dynamic>>> loadMenuData(String restaurantId) async {
//     print("Rest id $restaurantId");
//
//     final menuRawData = await rootBundle.loadString('assets/csvs/menu_new.csv');
//     final foodRawData = await rootBundle.loadString('assets/csvs/food_new.csv');
//
//     print("Menu raw $menuRawData");
//     print("Food raw $foodRawData");
//
//     List<List<dynamic>> menuListData =
//         const CsvToListConverter(eol: '\n').convert(menuRawData);
//     List<List<dynamic>> foodListData =
//         const CsvToListConverter(eol: '\n').convert(foodRawData);
//
//     print("Menu head naive: ${menuRawData[0]}");
//     List<dynamic> menuHeaderRow = menuListData[0];
//     List<dynamic> foodHeaderRow = foodListData[0];
//
//     print(menuListData);
//     print(foodListData);
//
//     print("Menu header $menuHeaderRow");
//     print("Food header $foodHeaderRow");
//
//     print("Menu length ${menuListData.length}");
//     print("Food length ${foodListData.length}");
//
//     List<Map<String, dynamic>> menuData = menuListData
//         .skip(1) // Skip the header row
//         .map((row) => Map.fromIterables(
//               menuHeaderRow.map((header) => header.toString()),
//               row,
//             ))
//         .toList();
//     print('All Menu Data:');
//     // menuData.forEach((item) => print(item));
//
// // Filter menuData based on restaurantId
//     List<Map<String, dynamic>> filteredMenuData = menuData
//         .where((menuItem) => menuItem['id'].toString() == restaurantId)
//         .toList();
//     print('Filtered Menu Data:');
//     // filteredMenuData.forEach((item) => print(item));
//
//     Set<String> uniqueIds = Set();
//     List<Map<String, dynamic>> uniqueMenuData = [];
//
//     filteredMenuData.forEach((menuItem) {
//       if (!uniqueIds.contains(menuItem['id'])) {
//         uniqueIds.add(menuItem['id'].toString());
//         uniqueMenuData.add(menuItem);
//       }
//     });
//
//     // List<Map<String, dynamic>> menuData = menuListData
//     //     .skip(1)
//     //     .map((row) => Map.fromIterables(
//     //           menuHeaderRow.map((header) => header.toString()),
//     //           row,
//     //         ))
//     //     .where((menuItem) => menuItem['id']==(restaurantId))
//     //     .toList();
//
//     List<Map<String, dynamic>> foodData = foodListData
//         .skip(1)
//         .map((row) => Map.fromIterables(
//               foodHeaderRow.map((header) => header.toString()),
//               row,
//             ))
//         .toList();
//
//     print("Menu data $filteredMenuData");
//     print("Food data $foodData");
//
//     List<Map<String, dynamic>> menuItemData = [];
//
//     for (var menuItem in uniqueMenuData) {
//       final foodId = menuItem['f_id'];
//       final foodItem = foodData.firstWhere(
//         (food) => food['f_id'] == foodId,
//       );
//
//       // print("food item : ${foodItem}");
//       // print("${foodItem.containsKey('item')}");
//       // print("${foodItem.containsKey('veg_or_non_veg')}");
//
//       if (foodItem != null && foodItem.containsKey('item')) {
//         menuItemData.add({
//           'cuisine': menuItem['cuisine'],
//           'item': foodItem['item'],
//           'veg_or_non_veg': foodItem['veg_or_non_veg'],
//           'price': menuItem['price'],
//         });
//       }
//     }
//
//     print("Menu item data $menuItemData");
//
//     return menuItemData;
//   }

  // List to store the user's cart items
  void addToCart(Map<String, dynamic> menuItem) {
    // Check if the item is already in the cart
    int index = _cartItems.indexWhere((i) => i.item.name == menuItem['item']);
    if (index != -1) {
      // Increment the quantity if the item is already in the cart
      _cartItems[index].quantity++;
    } else {
      // Create a MenuItem object from the Map
      MenuItem item = MenuItem(
        name: menuItem['item'],
        vegOrNonVeg: menuItem['veg_or_non_veg'],
        price: menuItem['price'],
        cuisine: menuItem['cuisine'],
      );
      // Add the item to the cart with a quantity of 1
      _cartItems.add(CartItem(item: item, quantity: 1));
    }
    setState(() {});
  }

  void removeFromCart(Map<String, dynamic> menuItem) {
    // Decrement the quantity if the quantity is greater than 1, or remove the item from the cart if the quantity is 1
    int index = _cartItems.indexWhere((i) => i.item.name == menuItem['item']);
    if (index != -1) {
      // Decrement the quantity if the quantity is greater than 1, or remove the item from the cart if the quantity is 1
      if (_cartItems[index].quantity > 1) {
        _cartItems[index].quantity--;
      } else {
        _cartItems.remove(_cartItems[index]);
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    int qty = 0;
    if (menuItems.isEmpty) {
      return Scaffold(
          body: Center(
        child: SpinKitWaveSpinner(
          color: TColor.primary,
          size: 50.0,
          // controller: AnimationController(vsync: this, duration: const Duration(milliseconds: 1200)),
        ),
      ));
    }
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [Colors.orange.withOpacity(0.6), Colors.white],
            begin: Alignment.topCenter),
      ),
      child: SingleChildScrollView(
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
                              "",
                              style: TextStyle(
                                  color: TColor.primaryText,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Get.to(() => MyOrderView(
                                    itemArr: [
                                      ..._cartItems.map((cartItem) => {
                                            "name": cartItem.item.name,
                                            "qty": cartItem.quantity.toString(),
                                            "price": cartItem.item.price,
                                          }),
                                    ],
                                    restArr: widget.restaurant,
                                  ));
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
                    RestaurantDetails(restaurant: widget.restaurant),
                    menuItems.isEmpty
                        ? Center(
                            child: SpinKitWaveSpinner(
                              color: TColor.primary,
                              size: 50.0,
                              // controller: AnimationController(vsync: this, duration: const Duration(milliseconds: 1200)),
                            ),
                          )
                        : StatefulBuilder(builder: (context, setState) {
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: menuItems.length,
                              itemBuilder: (context, index) {
                                final item = menuItems[index];
                                // final cartItem = cartItems.firstWhereOrNull(
                                //     (i) => i.item.name == item['name']);
                                return MenuFoodWidget(
                                  item: item,
                                  cartItems: _cartItems,
                                  addToCart: (menuItem) {
                                    setState(() {
                                      addToCart(menuItem);
                                    });
                                  },
                                  removeFromCart: (menuItem) {
                                    // Add the removeFromCart callback function here
                                    setState(() {
                                      removeFromCart(menuItem);
                                    });
                                  },
                                );
                              },
                            );
                          }),
                  ]))),
    ));
  }
}

class CartPage extends StatelessWidget {
  final List<CartItem> cartItems;

  CartPage({required this.cartItems});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          final item = cartItems[index];
          return Padding(
            padding: EdgeInsets.all(16.0),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16.0),
                      bottomLeft: Radius.circular(16.0),
                    ),
                    child: Image.asset(
                      "assets/img/menu_1.png",
                      width: 120.0,
                      height: 120.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.item.name,
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Quantity: ${item.quantity}',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                '\$${(item.item.price * item.quantity).toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
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
        },
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            // Place the order when the "Place Order" button is pressed
            // You can add your order placement logic here
            print('Order placed!');
          },
          child: Text('Place Order'),
        ),
      ),
    );
  }
}

class MenuItem {
  final String name;
  final String vegOrNonVeg;
  final price;
  final cuisine;

  MenuItem({
    required this.name,
    required this.vegOrNonVeg,
    required this.price,
    required this.cuisine,
  });
}

class CartItem {
  final MenuItem item;
  int quantity;

  CartItem({required this.item, required this.quantity});
}
