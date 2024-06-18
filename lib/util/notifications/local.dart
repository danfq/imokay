import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

///Local Notifications
class LocalNotifications {
  ///Local Notifications Plugin
  static final FlutterLocalNotificationsPlugin _localNotifs =
      FlutterLocalNotificationsPlugin();

  ///Setup Service
  static Future<void> setupService() async {
    //Android Permission
    if (Platform.isAndroid) {
      await _localNotifs
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()!
          .requestNotificationsPermission();
    }

    //iOS Permission
    if (Platform.isIOS) {
      await _localNotifs
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()!
          .requestPermissions();
    }

    //Android Initialization Settings
    const androidInitSettings = AndroidInitializationSettings("notif");

    //iOS Initialization Settings
    const iOSInitSettings = DarwinInitializationSettings(
      onDidReceiveLocalNotification: _onDidReceiveNotification,
    );

    //Service Initialization Settings
    const serviceInitSettings = InitializationSettings(
      android: androidInitSettings,
      iOS: iOSInitSettings,
    );

    //Initialize Service
    await _localNotifs
        .initialize(
          serviceInitSettings,
          onDidReceiveNotificationResponse: _onBackgroundNotifResponse,
        )
        .then((status) => debugPrint("[NOTIF] Initialized: $status."));
  }

  ///On Received Notification (Background)
  static void _onBackgroundNotifResponse(
    NotificationResponse response,
  ) async {
    //Log Notification
    debugPrint("[NOTIF] ID: ${response.id}.");
  }

  ///On Received Notification
  static void _onDidReceiveNotification(
    int id,
    String? title,
    String? body,
    String? payload,
  ) {
    //Log Notification
    debugPrint("[NOTIF] ID: $id | TITLE: $title.");
  }

  ///Show Local Notification with `title` & `message`
  static Future<void> notif({
    required String title,
    required String message,
  }) async {
    //Android Notification Details
    const androidDetails = AndroidNotificationDetails(
      "imokay_14",
      "I'm Okay",
      importance: Importance.high,
      priority: Priority.high,
    );

    //iOS Notification Details
    const iOSDetails = DarwinNotificationDetails();

    //Show Notification
    await _localNotifs.show(
      Random().nextInt(14),
      title,
      message,
      const NotificationDetails(
        android: androidDetails,
        iOS: iOSDetails,
      ),
    );
  }

  ///Show Platform-Adaptive Toast with `message`
  static void toast({required String message}) async {
    await Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      fontSize: 16.0,
    );
  }
}
