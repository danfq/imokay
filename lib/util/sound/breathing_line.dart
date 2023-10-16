import 'package:hive_flutter/adapters.dart';

///Breathing Line Controller
class BreathingLineController {
  ///Check if Any Sounds are Playing
  ///
  ///If so, the Breathing Line will be displayed.
  static bool soundsPlaying() {
    //Sounds Playing
    bool soundsPlaying = false;

    //Sounds Box
    final sounds = Hive.box("sounds").toMap();

    //Check if Any Sound is Playing
    for (final sound in sounds.entries) {
      if (sound.value == true) {
        soundsPlaying = true;
      } else {
        soundsPlaying = false;
      }
    }

    //Return Sounds State
    return soundsPlaying;
  }
}
