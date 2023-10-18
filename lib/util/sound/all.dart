import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

///All Sounds
Map<int, String> sounds = {
  0: "thunder",
  1: "wind",
  2: "birds",
  3: "waves",
  4: "fireplace",
  5: "vacuum",
  6: "talking",
  7: "tv_static",
  8: "brown_noise",
  9: "white_noise",
  10: "green_noise",
  11: "custom",
};

///Sound Icons
Map<String, IconData> soundIcons = {
  "thunder": Ionicons.thunderstorm_outline,
  "wind": Feather.wind,
  "birds": MaterialCommunityIcons.bird,
  "waves": MaterialCommunityIcons.waves,
  "fireplace": MaterialCommunityIcons.fireplace,
  "vacuum": MaterialCommunityIcons.vacuum,
  "talking": Ionicons.people,
  "tv_static": FontAwesome.tv,
  "brown_noise": Foundation.sound,
  "white_noise": Foundation.sound,
  "green_noise": Foundation.sound,
  "custom": Ionicons.ios_add,
};
