import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:imokay/util/notifications/local.dart';
import 'package:imokay/util/sound/manager.dart';
import 'package:imokay/util/storage/local.dart';

///Timer Sheet
class TimerSheet extends StatefulWidget {
  const TimerSheet({super.key});

  @override
  State<StatefulWidget> createState() => _TimerSheetState();
}

class _TimerSheetState extends State<TimerSheet> {
  late Timer _updateTimer;

  @override
  void initState() {
    super.initState();

    //Update Timer
    _updateTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _updateTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              "Timer",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
          ),

          //Timer UI - Based on timerRunning
          TimerHandler.timerRunning
              ? Text(TimerHandler.formatDuration(TimerHandler.timerDuration))
              : CupertinoTimerPicker(
                  initialTimerDuration: TimerHandler.timerDuration,
                  onTimerDurationChanged: (duration) {
                    setState(() {
                      TimerHandler.storedDuration = duration;
                      TimerHandler.timerDuration = duration;
                    });
                  },
                ),

          //Start or Stop Timer
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              onPressed: () {
                //Close Sheet
                Get.back();

                //Start or Stop Timer
                TimerHandler.timerRunning
                    ? TimerHandler.stopTimer()
                    : TimerHandler.startTimer(TimerHandler.timerDuration);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).dialogBackgroundColor,
              ),
              child: Text(
                TimerHandler.timerRunning ? "Stop Timer" : "Start Timer",
              ),
            ),
          ),
        ],
      ),
    );
  }
}

///Timer Handler
class TimerHandler {
  ///Timer Duration
  static Duration timerDuration = Duration.zero;

  ///Timer Running State
  static bool timerRunning = false;

  ///Timer Reference
  static Timer? _timer;

  /// Load Timer Duration from Storage
  static Duration? get storedDuration => parseDuration(
        LocalStorage.boxData(box: "timer")["duration"]?["string"],
      );

  ///Set Timer Duration to Storage
  static set storedDuration(Duration? duration) {
    LocalStorage.updateValue(box: "timer", item: "duration", value: {
      "string": duration.toString(),
    });
  }

  ///Format Duration into `HH:mm:ss` String
  static String formatDuration(Duration duration) {
    //Duration Parts
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    String hours = duration.inHours.toString();

    //Formatted Duration
    return "$hours:$twoDigitMinutes:$twoDigitSeconds";
  }

  ///Parse Timer Duration from `String` to `Duration`
  static Duration? parseDuration(String? duration) {
    if (duration != null) {
      try {
        List<String> parts = duration.split(":");
        if (parts.length != 3) {
          throw FormatException("Invalid Duration: $duration.");
        }

        int hours = int.parse(parts[0]);
        int minutes = int.parse(parts[1]);
        List<String> secondsParts = parts[2].split('.');
        int seconds = int.parse(secondsParts[0]);
        int microseconds = secondsParts.length > 1
            ? int.parse(secondsParts[1].padRight(6, '0'))
            : 0;

        return Duration(
          hours: hours,
          minutes: minutes,
          seconds: seconds,
          microseconds: microseconds,
        );
      } catch (error) {
        debugPrint("Error Parsing Duration: $duration.");
        return null;
      }
    }
    return null;
  }

  /// Start Timer
  static void startTimer(Duration duration) {
    storedDuration = duration;
    timerDuration = duration;
    timerRunning = true;

    //Cancel Previous Timer (if any)
    _timer?.cancel();

    //Set Timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (timerDuration > Duration.zero) {
        timerDuration -= const Duration(seconds: 1);
      } else {
        //Stop Timer
        stopTimer();

        //On Timer Complete
        await _onTimerComplete();
      }
    });

    //Notify User
    LocalNotifications.toast(message: "Timer Started");
  }

  /// Stop Timer
  static void stopTimer() {
    //Stop Timer
    _timer?.cancel();

    //Reset Data
    timerDuration = Duration.zero;
    timerRunning = false;
    storedDuration = null;

    //Stop All Players
    AudioPlayerManager.stopAllPlayers();
  }

  ///On Timer Complete
  static Future<void> _onTimerComplete() async {
    //Notify User
    await LocalNotifications.notif(
      title: "Time is up!",
      message: "Your Timer is over!",
    );

    //Stop All Players
    AudioPlayerManager.stopAllPlayers();
  }

  ///Show Timer Sheet
  static Future<void> showTimerSheet() async {
    await showModalBottomSheet(
      context: Get.context!,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(14.0),
        ),
      ),
      builder: (context) => const TimerSheet(),
    );
  }
}
