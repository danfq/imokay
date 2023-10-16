import 'package:flutter/material.dart';

class BreathingLine extends StatefulWidget {
  final bool isPlaying;

  const BreathingLine({Key? key, required this.isPlaying}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BreathingLineState();
}

class _BreathingLineState extends State<BreathingLine>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  //Breathing Status
  bool _breathingStatus = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
        reverseCurve: Curves.easeInOut,
      ),
    );

    if (widget.isPlaying) {
      _animationController.repeat(reverse: true);
    }

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
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) => ScaleTransition(
              scale: animation,
              child: child,
            ),
            child: !_breathingStatus
                ? const Text(
                    "Breathe In",
                    key: ValueKey("breathe-in"),
                  )
                : const Text(
                    "Breathe Out",
                    key: ValueKey("breathe-out"),
                  ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 20,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Align(
                  alignment: Alignment(_animation.value * 2 - 1, 0),
                  child: Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                      color: Theme.of(context).iconTheme.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
