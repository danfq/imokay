import 'dart:async';
import 'package:flutter/material.dart';
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
