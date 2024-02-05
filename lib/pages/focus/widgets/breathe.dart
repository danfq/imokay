import 'package:flutter/material.dart';

class FocusBreathe extends StatefulWidget {
  const FocusBreathe({super.key});

  @override
  State<FocusBreathe> createState() => _FocusBreatheState();
}

class _FocusBreatheState extends State<FocusBreathe>
    with SingleTickerProviderStateMixin {
  //Animation
  late AnimationController _animationController;

  ///Breathing Status
  bool _breathingStatus = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    //Text Animation
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.forward) {
        setState(() {
          _breathingStatus = false;
        });
      } else if (status == AnimationStatus.reverse) {
        setState(() {
          _breathingStatus = true;
        });
      }
    });

    //Repeat in Reverse
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) => ScaleTransition(
        scale: animation,
        child: child,
      ),
      child: !_breathingStatus
          ? const Text(
              "Breathe In",
              key: ValueKey("breathe-in"),
              style: TextStyle(fontSize: 22.0),
            )
          : const Text(
              "Breathe Out",
              key: ValueKey("breathe-out"),
              style: TextStyle(fontSize: 22.0),
            ),
    );
  }
}
