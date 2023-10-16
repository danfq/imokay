import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:imokay/util/notifications/incentives.dart';
import 'package:imokay/util/notifications/local.dart';

///Notification Handling
class NotificationHandler {
  //Local Notifications System
  static final FlutterLocalNotificationsPlugin localNotifications =
      FlutterLocalNotificationsPlugin();

  ///Request Permission
  static Future<bool> requestPermission() async {
    //Permission Status
    bool permissionStatus = false;

    //Request Permission - per `Platform`
    if (Platform.isAndroid) {
      localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()!
          .requestPermission()
          .then((status) => permissionStatus = status ?? false);
    } else if (Platform.isIOS) {
      localNotifications
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()!
          .requestPermissions()
          .then((status) => permissionStatus = status ?? false);
    }

    //Return Permission Status
    return permissionStatus;
  }

  ///Initialize Notifications Handler
  static Future<void> init() async {
    //Configurations per Platform
    const AndroidInitializationSettings androidInitSettings =
        AndroidInitializationSettings("ic_launcher");

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitSettings,
    );

    //Check if User Allowed Incentive Notifications
    if (IncentiveNotifications.current()) {
      //Initialize
      await localNotifications.initialize(initializationSettings);

      //Schedule Notification
      await IncentiveNotifications.createNotificationsSchedule();
    }
  }

  ///Disable Service
  static Future<void> disableService() async {
    await localNotifications.cancelAll();

    //Notify User
    LocalNotifications.toast(message: "Notification Service Disabled");
  }
}
