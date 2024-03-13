import 'dart:ui';

import 'package:flutter/material.dart';

class THelperFunctions {
  static Color? getColor(String value) {
    /// Define your product specific colors here and it will match the attribute colors and show specific
    if (value == 'Green') {
      return Colors.green;
    } else if (value == 'Green') {
      return Colors.green;
    } else if (value == 'Red') {
      return Colors.red;
    } else if (value == 'Blue') {
      return Colors.blue;
    } else if (value == 'Pink') {
      return Colors.pink;
    } else if (value == 'Grey') {
      return Colors.grey;
    } else if (value == 'Purple') {
      return Colors.purple;
    }
    else if (value == 'Black') {
      return Colors.black;
    } else if (value == 'White') {
      return Colors.white;
    }
    return null;
  }

  static bool isDarkMode(BuildContext context){
    return Theme.of(context).brightness==Brightness.dark;
  }
}