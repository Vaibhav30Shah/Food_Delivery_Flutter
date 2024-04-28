import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_delivery/authentication/authentication_helper.dart';
import 'package:food_delivery/common_widget/round_button.dart';
import 'package:food_delivery/view/login/login_view.dart';
import 'package:image_picker/image_picker.dart';

import '../../common/color_extension.dart';
import '../../common_widget/round_textfield.dart';
import '../more/my_order_view.dart';

class ProfileView extends StatefulWidget {
  final String? userEmail;
  final String? userMobile;
  final String? userAddress;
  final String? userName;
  final String? userProfilePicture;

  const ProfileView({
    super.key,
    this.userEmail,
    this.userMobile,
    this.userAddress,
    this.userName,
    this.userProfilePicture,
  });

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final ImagePicker picker = ImagePicker();
  XFile? image;

  TextEditingController txtName = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtMobile = TextEditingController();
  TextEditingController txtAddress = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  TextEditingController txtConfirmPassword = TextEditingController();

  @override
  void initState() {
    super.initState();
    txtEmail.text = widget.userEmail ?? '';
    txtMobile.text = widget.userMobile ?? '';
    txtAddress.text = widget.userAddress ?? '';
    txtName.text = widget.userName ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          const SizedBox(
            height: 46,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Profile",
                  style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 20,
                      fontWeight: FontWeight.w800),
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
          const SizedBox(
            height: 20,
          ),
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: TColor.placeholder,
              borderRadius: BorderRadius.circular(50),
            ),
            alignment: Alignment.center,
            child: widget.userProfilePicture != null
                ? image != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.file(File(image!.path),
                            width: 100, height: 100, fit: BoxFit.cover),
                      )
                    : ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.network(widget.userProfilePicture.toString(),
                  width: 100, height: 100, fit: BoxFit.cover),
            )
                : Icon(
                    Icons.person,
                    size: 65,
                    color: TColor.secondaryText,
                  ),
          ),
          TextButton.icon(
            onPressed: () async {
              image = await picker.pickImage(source: ImageSource.gallery);
              setState(() {});
            },
            icon: Icon(
              Icons.edit,
              color: TColor.primary,
              size: 12,
            ),
            label: Text(
              "Upload Image",
              style: TextStyle(color: TColor.primary, fontSize: 12),
            ),
          ),
          Text(
            "Hi there!",
            style: TextStyle(
                color: TColor.primaryText,
                fontSize: 16,
                fontWeight: FontWeight.w700),
          ),
          TextButton(
            onPressed: () async {
              await AuthenticationHelper().logout();
              // Navigate back to the LoginView
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginView()),
                (route) => false,
              );
            },
            child: Text(
              "Sign Out",
              style: TextStyle(
                  color: TColor.secondaryText,
                  fontSize: 11,
                  fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            child: RoundTitleTextfield(
              title: "Name",
              hintText: "Enter Name",
              controller: txtName,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            child: RoundTitleTextfield(
              title: "Email",
              hintText: "Enter Email",
              keyboardType: TextInputType.emailAddress,
              controller: txtEmail,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            child: RoundTitleTextfield(
              title: "Mobile No",
              hintText: "Enter Mobile No",
              controller: txtMobile,
              keyboardType: TextInputType.phone,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            child: RoundTitleTextfield(
              title: "Address",
              hintText: "Enter Address",
              controller: txtAddress,
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          //   child: RoundTitleTextfield(
          //     title: "Password",
          //     hintText: "* * * * * *",
          //     obscureText: true,
          //     controller: txtPassword,
          //   ),
          // ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          //   child: RoundTitleTextfield(
          //     title: "Confirm Password",
          //     hintText: "* * * * * *",
          //     obscureText: true,
          //     controller: txtConfirmPassword,
          //   ),
          // ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: RoundButton(title: "Save", onPressed: () {}),
          ),
          const SizedBox(
            height: 20,
          ),
        ]),
      ),
    ));
  }
}
