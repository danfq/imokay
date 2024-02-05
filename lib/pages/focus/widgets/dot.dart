import 'dart:math';
import 'package:flutter/material.dart';

class FocusDot extends StatefulWidget {
  const FocusDot({Key? key}) : super(key: key);

  @override
  State<FocusDot> createState() => _FocusDotState();
}

class _FocusDotState extends State<FocusDot>
    with SingleTickerProviderStateMixin {
  //Animation
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
      reverseDuration: const Duration(seconds: 4),
    )..repeat(reverse: true);
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return CustomPaint(
          painter: _FocusDotPainter(
            animationValue: _animation.value,
            context: context,
          ),
          child: Container(),
        );
      },
    );
  }
}

class _FocusDotPainter extends CustomPainter {
  ///Animation Value
  final double animationValue;

  ///Context
  final BuildContext context;

  _FocusDotPainter({required this.animationValue, required this.context});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 4;

    final paint = Paint()
      ..color = Theme.of(context).iconTheme.color!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    //Breathing Circle
    final breathRadius = radius * (1 + animationValue * 0.6);
    canvas.drawCircle(center, breathRadius, paint);

    //Inner
    const ballRadius = 20.0;
    paint.style = PaintingStyle.fill;
    paint.color = Theme.of(context).iconTheme.color!.withOpacity(0.8);
    canvas.drawCircle(center, ballRadius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
