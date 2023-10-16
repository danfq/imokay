import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

///Theme Controller
class ThemeController {
  ///Current Theme
  static bool current({required BuildContext context}) {
    //Current Theme
    return AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark;
  }

  ///Current `ThemeMode`
  static ThemeMode currentThemeMode({required BuildContext context}) {
    return current(context: context) ? ThemeMode.dark : ThemeMode.light;
  }

  ///Change Theme
  static void setTheme({
    required BuildContext context,
    required bool mode,
  }) {
    switch (mode) {
      case true:
        AdaptiveTheme.of(context).setDark();
        break;
      case false:
        AdaptiveTheme.of(context).setLight();
        break;
    }

    //Immersion
    ThemeController.immersion(context: context);
  }

  ///Immersion
  static void immersion({
    required BuildContext context,
  }) {
    //Set System Navigation
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: ThemeController.current(context: context)
            ? const Color(0xFF161B22)
            : const Color(0xFFF2F2F2),
      ),
    );
  }
}
