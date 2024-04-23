import 'package:flutter/material.dart';

class AddButton extends StatelessWidget {
  final VoidCallback onPressed;
  const AddButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.red, // Set the background color of the button
          borderRadius: BorderRadius.circular(20), // Add rounded corners
        ),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Add padding
        child: Row(
          mainAxisSize: MainAxisSize.min, // Ensure the Row takes up minimum space
          children: [
            Text(
              'ADD',
              style: TextStyle(
                color: Colors.white, // Set the text color
                fontWeight: FontWeight.bold, // Make the text bold
              ),
            ),
            SizedBox(width: 8), // Add spacing between text and icon
            Icon(
              Icons.add, // Add the "+" icon
              color: Colors.white, // Set the icon color
              size: 18, // Adjust the icon size
            ),
          ],
        ),
      ),
    );
  }
}
