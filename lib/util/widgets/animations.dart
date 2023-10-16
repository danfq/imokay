import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';

///Animations Handling
class AnimationsHandler {
  ///Asset Animation
  static LottieBuilder asset({
    required String name,
    bool? repeat,
    double? height,
  }) {
    return LottieBuilder.asset(
      "assets/animations/$name.json",
      height: height,
      frameRate: FrameRate.max,
      filterQuality: FilterQuality.high,
      repeat: repeat,
      animate: true,
    );
  }
}
