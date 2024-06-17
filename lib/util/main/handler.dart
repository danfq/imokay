import 'package:flutter/material.dart';
import 'package:imokay/util/notifications/local.dart';
import 'package:imokay/util/storage/local.dart';

///Main Services Handler
class ServicesHandler {
  ///Initialize Services
  static Future<void> init() async {
    //Ensure Binding is Initialized
    WidgetsFlutterBinding.ensureInitialized();

    //Initialize Local Storage
    await LocalStorage.init();

    //Initialize Local Notifications
    await LocalNotifications.setupService();
  }
}
