import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imokay/util/notifications/local.dart';
import 'package:imokay/util/sound/manager.dart';
import 'package:imokay/util/storage/local.dart';

class TimerHandler extends GetxController {
  /// Reactive Timer Duration
  var timerDuration = Duration.zero.obs;

  /// Reactive Timer Running State
  var timerRunning = false.obs;

  /// Timer Reference
  Timer? _timer;

  /// Load Timer Duration from Storage
  Duration? get storedDuration => parseDuration(
        LocalStorage.boxData(box: "timer")["duration"]?["string"],
      );

  /// Set Timer Duration to Storage
  set storedDuration(Duration? duration) {
    LocalStorage.updateValue(box: "timer", item: "duration", value: {
      "string": duration.toString(),
    });
  }

  /// Parse Timer Duration from `String` to `Duration`
  Duration? parseDuration(String? duration) {
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
  void startTimer(Duration duration) {
    storedDuration = duration;
    timerDuration.value = duration;
    timerRunning.value = true;

    //Debug
    debugPrint("TIMER: ${timerRunning.value}.");

    //Cancel Previous Timer (if any)
    _timer?.cancel();

    //Set Timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (timerDuration.value > Duration.zero) {
        timerDuration.value -= const Duration(seconds: 1);
      } else {
        //Stop Timer
        stopTimer();

        //On Timer Complete
        await _onTimerComplete();
      }
    });
  }

  ///Stop Timer
  void stopTimer() {
    //Stop Timer
    _timer?.cancel();

    //Reset Data
    timerDuration.value = Duration.zero;
    timerRunning.value = false;
    storedDuration = null;

    //Debug
    debugPrint("TIMER: ${timerRunning.value}.");
  }

  /// On Timer Complete
  Future<void> _onTimerComplete() async {
    await LocalNotifications.notif(
      title: "Time is up!",
      message: "Your Timer is over!",
    );
    AudioPlayerManager.stopAllPlayers();
  }

  /// Show Timer Sheet
  Future<void> showTimerSheet() async {
    await showModalBottomSheet(
      context: Get.context!,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(14.0),
        ),
      ),
      builder: (context) => SizedBox(
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

            // Timer UI
            CupertinoTimerPicker(
              initialTimerDuration: timerDuration.value,
              onTimerDurationChanged: (duration) {
                storedDuration = duration;
                timerDuration.value = duration;
              },
            ),

            // Set Timer Duration
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                onPressed: () {
                  Get.back();
                  startTimer(timerDuration.value);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).dialogBackgroundColor,
                ),
                child: const Text("Start Timer"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
