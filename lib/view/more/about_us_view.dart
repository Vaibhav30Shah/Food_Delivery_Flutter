import 'package:flutter/material.dart';
import 'package:food_delivery/common/color_extension.dart';

import 'my_order_view.dart';

import 'package:flutter/material.dart';

class AboutUsView extends StatelessWidget {
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
                          child: Row(children: [
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
                                "About Us",
                                style: TextStyle(
                                    color: TColor.primaryText,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800),
                              ),
                            ),
                          ])),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildHeader(),
                                  SizedBox(height: 20.0),
                                  _buildHeroSection(),
                                  SizedBox(height: 20.0),
                                  _buildIntroduction(),
                                  SizedBox(height: 30.0),
                                  _buildKeyFeatures(),
                                  SizedBox(height: 30.0),
                                  _buildTeamSection(),
                                  SizedBox(height: 30.0),
                                  _buildMissionAndValues(),
                                  SizedBox(height: 30.0),
                                  _buildTestimonials(),
                                  SizedBox(height: 30.0),
                                  _buildContactInfo(),
                                ],
                              ),
                            )
                    ]))));
  }

  Widget _buildHeader() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        'Welcome to Our Food Delivery App',
        style: TextStyle(

          fontSize: 24.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      alignment: Alignment.center,
      child: Image.asset(
        'assets/img/logo.png', // Placeholder for hero image
        height: 200.0,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildIntroduction() {
    return Text(
      'Our food delivery app is dedicated to providing delicious meals at your doorstep with speedy service and a diverse menu selection. We prioritize customer satisfaction and quality ingredients.',
      style: TextStyle(fontSize: 16.0),
    );
  }

  Widget _buildKeyFeatures() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Key Features:',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10.0),
        _buildFeatureItem('Fast Delivery', Icons.delivery_dining),
        _buildFeatureItem('Diverse Cuisine Options', Icons.restaurant_menu),
        _buildFeatureItem('User-Friendly Interface', Icons.smartphone),
        _buildFeatureItem('Secure Payment Methods', Icons.payment),
      ],
    );
  }

  Widget _buildFeatureItem(String title, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon),
          SizedBox(width: 10.0),
          Text(title),
        ],
      ),
    );
  }

  Widget _buildTeamSection() {
    // Placeholder for team member profiles (can use ListView or GridView)
    return Container(
      alignment: Alignment.center,
      child: Text(
        'Meet Our Team',
        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildMissionAndValues() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Our Mission & Values:',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10.0),
        Text(
          'Deliver exceptional culinary experiences to our customers while supporting local communities and sustainable practices.',
          style: TextStyle(fontSize: 16.0),
        ),
      ],
    );
  }

  Widget _buildTestimonials() {
    // Placeholder for customer testimonials (can use ListView or Carousel)
    return Container(
      alignment: Alignment.center,
      child: Text(
        'Customer Testimonials',
        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildContactInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contact Us:',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10.0),
        Text(
          'For inquiries and support, please email us at support@example.com',
          style: TextStyle(fontSize: 16.0),
        ),
        SizedBox(height: 10.0),
        Text(
          'Follow us on social media:',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10.0),
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.email),
              onPressed: () {
                // Handle email button action
              },
            ),
            IconButton(
              icon: Icon(Icons.facebook),
              onPressed: () {
                // Handle Facebook button action
              },
            ),
          ],
        ),
      ],
    );
  }
}

// class AboutUsView extends StatefulWidget {
//   const AboutUsView({super.key});
//
//   @override
//   State<AboutUsView> createState() => _AboutUsViewState();
// }
//
// class _AboutUsViewState extends State<AboutUsView> {
//   List aboutTextArr = [
//
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(
//                 height: 46,
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 15),
//                 child: Row(
//                   children: [
//                     IconButton(
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                       icon: Image.asset("assets/img/btn_back.png",
//                           width: 20, height: 20),
//                     ),
//                     const SizedBox(
//                       width: 8,
//                     ),
//                     Expanded(
//                       child: Text(
//                         "About Us",
//                         style: TextStyle(
//                             color: TColor.primaryText,
//                             fontSize: 20,
//                             fontWeight: FontWeight.w800),
//                       ),
//                     ),
//                     IconButton(
//                       onPressed: () {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => const MyOrderView()));
//                       },
//                       icon: Image.asset(
//                         "assets/img/shopping_cart.png",
//                         width: 25,
//                         height: 25,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               ListView.builder(
//                 physics: const NeverScrollableScrollPhysics(),
//                 shrinkWrap: true,
//                 padding: EdgeInsets.zero,
//                 itemCount: aboutTextArr.length,
//
//                 itemBuilder: ((context, index) {
//                   var txt = aboutTextArr[index] as String? ?? "";
//                   return Container(
//                     padding: const EdgeInsets.symmetric(
//                         vertical: 15, horizontal: 25),
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Container(
//                           margin: const EdgeInsets.only(top: 4),
//                           width: 6,
//                           height: 6,
//                           decoration: BoxDecoration(
//                               color: TColor.primary,
//                               borderRadius: BorderRadius.circular(4)),
//                         ),
//                         const SizedBox(
//                           width: 15,
//                         ),
//                         Expanded(
//                           child: Text(
//                             txt,
//                             style: TextStyle(
//                                 color: TColor.primaryText,
//                                 fontSize: 14),
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 }),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
