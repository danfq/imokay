import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:imokay/util/notifications/handler.dart';
import 'package:imokay/util/storage/local.dart';
import 'package:timezone/standalone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as timezones;

///Incentive Notifications
class IncentiveNotifications {
  ///Incentives List
  static final List<String> incentives = [
    "Take a deep breath and find your calm.",
    "You're stronger than your anxiety.",
    "Embrace the present moment and let go of worries.",
    "Relax your mind and body with soothing sounds in the app.",
    "Trust in yourself and your ability to overcome anxiety.",
    "Find peace within, one breath at a time.",
    "You have the power to choose calmness over anxiety.",
    "Remember to listen to soothing sounds for instant relaxation.",
    "Release tension and find serenity within yourself.",
    "Every breath brings you closer to tranquility.",
    "Be gentle with yourself and practice self-compassion.",
    "Allow the soothing sounds to guide you to a peaceful state.",
    "Let go of what you can't control and focus on inner peace.",
    "Breathe in relaxation, breathe out anxiety.",
    "Nurture your mind and body with calming sounds in the app.",
    "Your inner strength is greater than your anxiety.",
    "Find comfort in the present moment, free from worry.",
    "Create a sanctuary of calmness with soothing sounds.",
    "Embrace stillness and invite tranquility into your life.",
    "Trust in the process of healing and finding peace.",
    "Shift your focus to the soothing sounds for a moment of tranquility.",
    "You have the resilience to overcome anxious thoughts.",
    "Practice self-care and prioritize your well-being.",
    "Quiet your mind, let go of stress, and embrace calmness.",
    "Find solace in the gentle sounds that bring you peace.",
    "You are capable of finding peace within the chaos.",
    "Release tension and find serenity with the help of soothing sounds.",
    "Each day brings new opportunities for relaxation and tranquility.",
    "Allow the soothing sounds to carry you to a place of calm.",
    "Trust in your ability to find peace, even in challenging moments.",
    "Embrace the soothing sounds as your companion for relaxation.",
    "Find comfort in the simplicity of the present moment.",
    "Cultivate inner peace by immersing yourself in calming sounds.",
    "Your calmness is a powerful antidote to anxiety.",
    "Connect with the soothing sounds to ease your anxious mind.",
    "Let go of worries and embrace the tranquility within.",
    "Breathe deeply and feel the tension melting away.",
    "You deserve moments of peace and serenity.",
    "Anchor yourself in the present and let anxiety drift away.",
    "Take a mental vacation with the soothing sounds in the app.",
    "Each inhale brings relaxation, each exhale releases tension.",
    "Create a peaceful space within your mind with soothing sounds.",
    "You possess the strength to find calmness amidst anxiety.",
    "Tune into the soothing sounds for instant relaxation.",
    "Surrender to the present moment and find peace within.",
    "Surround yourself with gentle sounds to calm your anxious thoughts.",
    "Quiet your mind, listen to the soothing sounds, and find tranquility.",
    "Trust in the process of self-care and finding inner peace.",
    "«I'm so much more than the bad things that happen to me.»", //Jane <3
    "«You can't wait until life isn't hard anymore before you decide to be happy.»", //Jane <3
  ];

  ///Load Incentives into Memory
  static Future<void> loadIncentivesInMemory() async {
    await LocalStorage.setData(
      box: "incentives",
      data: {
        "list": incentives,
      },
    );
  }

  ///Current Status
  static bool current() {
    //Check Status
    final preferences = LocalStorage.boxData(box: "preferences");
    final currentStatus = preferences?["incentive_notifications"];

    //Return Current Status
    return currentStatus ?? false;
  }

  ///Set Mode
  static Future<void> setMode({
    required bool mode,
  }) async {
    //Preferences
    final preferences = Hive.box("preferences");

    //Set Mode
    preferences.put("incentive_notifications", mode);

    //Initialize Notifications Service if Allowed
    if (mode) {
      await NotificationHandler.init();
    } else {
      await NotificationHandler.disableService();
    }
  }

  ///Create Notifications Schedule
  static Future<void> createNotificationsSchedule() async {
    //Initialize Timezone Database
    timezones.initializeTimeZones();

    //Current Timezone
    String currentTimezone = await FlutterNativeTimezone.getLocalTimezone();

    //Timezone Location
    tz.Location timezoneLocation = tz.getLocation(currentTimezone);

    //Android Notification Details
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      "14",
      "imokay",
      importance: Importance.max,
      priority: Priority.high,
    );

    //Notification Details
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    //Daily Notification Schedule
    final random = Random();

    for (int day = DateTime.monday; day <= DateTime.sunday; day++) {
      //Random Time
      final randomHour = random.nextInt(24);
      final randomMinute = random.nextInt(60);

      //Date & Time Schedule
      final scheduledDate = DateTime.now().subtract(
        Duration(days: DateTime.now().weekday - day),
      );

      final scheduledTime = Time(randomHour, randomMinute, 0);

      final tz.TZDateTime scheduledDateTime = tz.TZDateTime(
        timezoneLocation,
        scheduledDate.year,
        scheduledDate.month,
        scheduledDate.day,
        scheduledTime.hour,
        scheduledTime.minute,
      );

      //Random Incentive
      final int randomIncentiveIndex = random.nextInt(
        incentives.length,
      );

      final String randomIncentive = incentives[randomIncentiveIndex];

      //Create Schedule
      await NotificationHandler.localNotifications.zonedSchedule(
        day * 14, //Unique ID per Notification
        "I'm Okay",
        randomIncentive,
        TZDateTime.from(scheduledDateTime, tz.local),
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
        payload: "random_incentive",
      );
    }
  }
}
