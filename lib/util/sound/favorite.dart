import 'package:hive_flutter/adapters.dart';

///Favorite Sounds
class FavoriteSounds {
  ///Change Status
  static Future<void> update({
    required String soundName,
    required bool status,
  }) async {
    //Update Favorite Status
    final favoritesBox = Hive.box("favorites");

    if (status) {
      await favoritesBox.put(soundName, status);
    } else {
      await favoritesBox.delete(soundName);
    }
  }
}
