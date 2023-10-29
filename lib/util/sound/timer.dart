import 'dart:async';
import 'package:flutter/material.dart';
import 'package:imokay/util/notifications/local.dart';
import 'package:imokay/util/sound/manager.dart';

class CountdownTimer extends StatefulWidget {
  const CountdownTimer({super.key, required this.duration});

  //Parameters
  final Duration duration;

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  //Timer
  late Timer _timer;
  late Duration _remainingDuration;

  @override
  void initState() {
    super.initState();
    _remainingDuration = widget.duration;
    _startTimer();
  }

  @override
  void dispose() {
    //Cancel Timer
    _timer.cancel();

    //Stop all Players
    AudioPlayerManager.stopAllPlayers();

    //Dispose
    super.dispose();
  }

  ///Start Timer
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingDuration.inSeconds > 0) {
          _remainingDuration = _remainingDuration - const Duration(seconds: 1);
        } else {
          _timer.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      "${_remainingDuration.inHours}:${_remainingDuration.inMinutes.remainder(60).toString().padLeft(2, '0')}:${_remainingDuration.inSeconds.remainder(60).toString().padLeft(2, '0')}",
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

///Timer Picker Widget
class TimerPicker extends StatefulWidget {
  const TimerPicker({
    super.key,
    required this.initialDurationInMinutes,
    required this.onDurationChanged,
  });

  final int initialDurationInMinutes;
  final ValueChanged<Duration> onDurationChanged;

  @override
  State<StatefulWidget> createState() => _TimerPickerState();
}

class _TimerPickerState extends State<TimerPicker> {
  late int selectedMinutes;

  @override
  void initState() {
    super.initState();
    selectedMinutes = widget.initialDurationInMinutes;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Slider(
          value: selectedMinutes.toDouble(),
          min: 5,
          max: 60,
          divisions: 11, //Increments of 5 Minutes Each
          onChanged: (value) {
            setState(() {
              selectedMinutes = value.toInt();
            });

            //Pass New Duration Back
            widget.onDurationChanged(Duration(minutes: selectedMinutes));
          },
        ),
        Text(
          selectedMinutes == 0 ? "No Timer" : "$selectedMinutes Minutes",
        ),
      ],
    );
  }
}

///Timer Handler
class TimerHandler {
  ///Open Timer Sheet
  static Future<void> openSheet({
    required BuildContext context,
    required bool timerInProgress,
    required Duration timerDuration,
    required bool audioPlaying,
  }) async {
    //Check if Timer is Active
    if (!timerInProgress) {
      //Show Timer Sheet
      await showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(14.0),
          ),
        ),
        isScrollControlled: true,
        builder: (context) {
          //Readable Time
          var readableTime = "${timerDuration.inMinutes} Minutes";

          return StatefulBuilder(
            builder: (context, setInside) {
              return SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Card(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(14.0),
                          ),
                        ),
                        child: ListTile(
                          title: const Text("Duration"),
                          trailing: Text(
                            readableTime,
                          ),
                          onTap: () async {
                            await showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.all(
                                          20.0,
                                        ),
                                        child: Text(
                                          "Set Timer Duration",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20.0,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(
                                          20.0,
                                        ),
                                        child: TimerPicker(
                                          initialDurationInMinutes:
                                              timerDuration.inMinutes,
                                          onDurationChanged: (duration) {
                                            setInside(() {
                                              timerDuration = duration;
                                              readableTime =
                                                  "${timerDuration.inMinutes} Minutes";
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            //Timer Status
                            setInside(() {
                              timerInProgress = true;
                            });

                            Future.delayed(timerDuration, () {
                              setInside(() {
                                timerInProgress = false;
                                audioPlaying = false;
                              });
                            });

                            //Close Sheet
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(
                              context,
                            ).cardColor,
                          ),
                          child: const Text("Set Timer"),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      );
    } else {
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Timer Active"),
            content: const Text(
              "A Timer is already active.\n\nWould you like to cancel it?",
            ),
            actions: [
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        //Close Dialog
                        Navigator.pop(context);

                        //Cancel Active Timer
                        timerInProgress = false;

                        //Stop All AudioPlayers
                        AudioPlayerManager.stopAllPlayers();

                        //Notify User
                        LocalNotifications.toast(
                          message: "Timer Cancelled",
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).cardColor,
                      ),
                      child: const Text(
                        "Cancel Active Timer",
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        //Do Nothing - Close Dialog
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).cardColor,
                      ),
                      child: const Text(
                        "Proceed with Current Timer",
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      );
    }
  }
}
