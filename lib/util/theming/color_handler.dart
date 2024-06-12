import 'package:flutter/material.dart';

///Color Handler
class ColorHandler {
  ///Convert Color String to Color Object
  static Color? colorFromString(String? colorString) {
    if (colorString != null) {
      //Remove Unwanted Portions
      String hexString =
          colorString.replaceAll("Color(", "").replaceAll(")", "");

      //Convert Hex to Int
      int hexValue = int.parse(hexString);

      //Return Resulting Color
      return Color(hexValue);
    }

    return null;
  }
}
