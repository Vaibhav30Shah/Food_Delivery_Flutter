import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_delivery/common/color_extension.dart';
import 'package:food_delivery/common_widget/add_button.dart';
import 'package:food_delivery/view/menu/restaurant_details.dart';
import 'package:get/get.dart';
import 'package:food_delivery/view/more/my_order_view.dart';

class RestaurantMenu extends StatefulWidget {
  final restaurant;

  const RestaurantMenu({Key? key, this.restaurant}) : super(key: key);

  @override
  _RestaurantMenuState createState() => _RestaurantMenuState();
}

class _RestaurantMenuState extends State<RestaurantMenu> {
  List menuItems = [];

  void navigateToMyOrderView(MenuItem item) {
    Get.to(() => MyOrderView(
          itemArr: [
            ...cartItems.map((cartItem) => {
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
    fetchMenuItems();
  }

  Future<void> fetchMenuItems() async {
    final String restaurantId = widget.restaurant['id'].toString();

    final menuData = await loadMenuData(restaurantId);

    menuItems = menuData.map((menuItem) {
      return MenuItem(
          name: menuItem['item'] ?? '',
          vegOrNonVeg: menuItem['veg_or_non_veg'] ?? '',
          price: menuItem['price'] ?? 0.0,
          cuisine: menuItem['cuisine'] ?? '');
    }).toList();

    setState(() {});
  }

  Future<List<Map<String, dynamic>>> loadMenuData(String restaurantId) async {
    print("Rest id $restaurantId");

    final menuRawData = await rootBundle.loadString('assets/csvs/menu_new.csv');
    final foodRawData = await rootBundle.loadString('assets/csvs/food_new.csv');

    print("Menu raw $menuRawData");
    print("Food raw $foodRawData");

    List<List<dynamic>> menuListData =
        const CsvToListConverter(eol: '\n').convert(menuRawData);
    List<List<dynamic>> foodListData =
        const CsvToListConverter(eol: '\n').convert(foodRawData);

    print("Menu head naive: ${menuRawData[0]}");
    List<dynamic> menuHeaderRow = menuListData[0];
    List<dynamic> foodHeaderRow = foodListData[0];

    print(menuListData);
    print(foodListData);

    print("Menu header $menuHeaderRow");
    print("Food header $foodHeaderRow");

    print("Menu length ${menuListData.length}");
    print("Food length ${foodListData.length}");

    List<Map<String, dynamic>> menuData = menuListData
        .skip(1) // Skip the header row
        .map((row) => Map.fromIterables(
              menuHeaderRow.map((header) => header.toString()),
              row,
            ))
        .toList();
    print('All Menu Data:');
    // menuData.forEach((item) => print(item));

// Filter menuData based on restaurantId
    List<Map<String, dynamic>> filteredMenuData = menuData
        .where((menuItem) => menuItem['id'].toString() == restaurantId)
        .toList();
    print('Filtered Menu Data:');
    filteredMenuData.forEach((item) => print(item));

    Set<String> uniqueIds = Set();
    List<Map<String, dynamic>> uniqueMenuData = [];

    filteredMenuData.forEach((menuItem) {
      if (!uniqueIds.contains(menuItem['id'])) {
        uniqueIds.add(menuItem['id'].toString());
        uniqueMenuData.add(menuItem);
      }
    });

    // List<Map<String, dynamic>> menuData = menuListData
    //     .skip(1)
    //     .map((row) => Map.fromIterables(
    //           menuHeaderRow.map((header) => header.toString()),
    //           row,
    //         ))
    //     .where((menuItem) => menuItem['id']==(restaurantId))
    //     .toList();

    List<Map<String, dynamic>> foodData = foodListData
        .skip(1)
        .map((row) => Map.fromIterables(
              foodHeaderRow.map((header) => header.toString()),
              row,
            ))
        .toList();

    print("Menu data $filteredMenuData");
    print("Food data $foodData");

    List<Map<String, dynamic>> menuItemData = [];

    for (var menuItem in uniqueMenuData) {
      final foodId = menuItem['f_id'];
      final foodItem = foodData.firstWhere(
        (food) => food['f_id'] == foodId,
      );

      if (foodItem != null &&
          foodItem.containsKey('item') &&
          foodItem.containsKey('veg_or_non_veg')) {
        menuItemData.add({
          'cuisine': menuItem['cuisine'],
          'item': foodItem['item'],
          'veg_or_non_veg': foodItem['veg_or_non_veg'],
          'price': menuItem['price'],
        });
      }
    }

    print("Menu item data $menuItemData");

    return menuItemData;
  }

  // List to store the menu items
  // List<MenuItem> menuItems = [
  //   MenuItem(
  //     name: 'Cheeseburger',
  //     description: 'Juicy beef patty with melted cheddar cheese, lettuce, tomato, and onion on a toasted bun.',
  //     price: 9.99,
  //     image: 'assets/img/offer_1.png',
  //   ),
  //   MenuItem(
  //     name: 'Chicken Salad',
  //     description: 'Grilled chicken breast, mixed greens, cherry tomatoes, cucumbers, and a light balsamic vinaigrette.',
  //     price: 12.50,
  //     image: 'assets/img/offer_1.png',
  //   ),
  //   MenuItem(
  //     name: 'Pasta Primavera',
  //     description: 'Penne pasta tossed with sautéed vegetables in a garlic-infused olive oil sauce.',
  //     price: 15.75,
  //     image: 'assets/img/offer_1.png',
  //   ),
  //   MenuItem(
  //     name: 'Vegetable Stir-Fry',
  //     description: 'A medley of fresh vegetables stir-fried in a savory soy-based sauce, served over jasmine rice.',
  //     price: 11.25,
  //     image: 'assets/img/offer_1.png',
  //   ),
  // ];

  // List to store the user's cart items
  List<CartItem> cartItems = [];

  void addToCart(MenuItem item) {
    // Check if the item is already in the cart
    int index = cartItems.indexWhere((i) => i.item.name == item.name);
    if (index != -1) {
      // Increment the quantity if the item is already in the cart
      cartItems[index].quantity++;
    } else {
      // Add the item to the cart with a quantity of 1
      cartItems.add(CartItem(item: item, quantity: 1));
    }
    setState(() {});
  }

  void removeFromCart(CartItem item) {
    // Decrement the quantity if the quantity is greater than 1, or remove the item from the cart if the quantity is 1
    if (item.quantity > 1) {
      item.quantity--;
    } else {
      cartItems.remove(item);
    }
    setState(() {});
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
                                    ...cartItems.map((cartItem) => {
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
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: menuItems.length,
                        itemBuilder: (context, index) {
                          final item = menuItems[index];
                          final cartItem = cartItems.firstWhereOrNull(
                              (i) => i.item.name == item.name);
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
                                            item.name,
                                            style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 8.0),
                                          Text(
                                            item.cuisine == null
                                                ? ' '
                                                : item.cuisine,
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
                                                '₹ ${item.price.toStringAsFixed(2)}',
                                                style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight:
                                                      FontWeight.bold,
                                                ),
                                              ),
                                              if (cartItem != null)
                                                Row(
                                                  children: [
                                                    IconButton(
                                                      icon: Icon(
                                                          Icons.remove),
                                                      onPressed: () {
                                                        removeFromCart(
                                                            cartItem);
                                                      },
                                                    ),
                                                    Text(cartItem.quantity
                                                        .toString()),
                                                    IconButton(
                                                      icon:
                                                          Icon(Icons.add),
                                                      onPressed: () {
                                                        addToCart(item);
                                                      },
                                                    ),
                                                  ],
                                                )
                                              else
                                                AddButton(
                                                  onPressed: () {
                                                    addToCart(item);
                                                  },
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
                    ]))));
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
