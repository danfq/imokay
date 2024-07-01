import 'package:flutter/material.dart';
import 'package:imokay/util/notifications/local.dart';
import 'package:imokay/util/storage/local.dart';
import 'package:logger/web.dart';

///Main Services Handler
class ServicesHandler {
  ///Logger
  static final Logger _logger = Logger();

  ///Initialize Services
  static Future<void> init() async {
    //Ensure Binding is Initialized
    WidgetsFlutterBinding.ensureInitialized();
    _logger.i("[INIT] Widgets Binding.");

    //Initialize Local Storage
    await LocalStorage.init();
    _logger.i("[INIT] Local Storage.");

    //Initialize Local Notifications
    await LocalNotifications.setupService();
    _logger.i("[INIT] Notifications.");
  }
}
