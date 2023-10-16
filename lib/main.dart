import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:imokay/pages/home.dart';
import 'package:imokay/util/notifications/handler.dart';
import 'package:imokay/util/notifications/incentives.dart';
import 'package:imokay/util/storage/local.dart';
import 'package:imokay/util/theming/themes.dart';

void main() async {
  //Ensure Binding is Initialized
  WidgetsFlutterBinding.ensureInitialized();

  //Initialize Local Storage
  await LocalStorage.init();

  //Initialize Notifications System
  await NotificationHandler.init();

  //Load Incentives Into Memory
  await IncentiveNotifications.loadIncentivesInMemory();

  //Run App
  runApp(
    AdaptiveTheme(
      light: Themes.light(),
      dark: Themes.dark(),
      initial: AdaptiveThemeMode.dark,
      builder: (light, dark) {
        return MaterialApp(
          theme: light,
          darkTheme: dark,
          home: const Home(),
        );
      },
    ),
  );
}
