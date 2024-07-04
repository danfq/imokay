import 'package:flutter/material.dart';

/// Color Handler
class ColorHandler {
  ///Convert Color to HEX String
  static String colorToHexString(Color color) {
    return "#${color.value.toRadixString(16).padLeft(8, "0")}";
  }

  ///Convert HEX String to Color
  static Color? hexToColor(String? hexColor) {
    return hexColor != null
        ? Color(int.parse(hexColor.replaceFirst("#", "0xff")))
        : null;
  }
}
