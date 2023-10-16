import 'package:hive_flutter/adapters.dart';
import 'package:imokay/util/models/sound_data.dart';
part 'groups.g.dart';

///Group
@HiveType(typeId: 0)
class Group {
  @HiveField(0)
  String name;

  @HiveField(1)
  List<SoundData> sounds;

  Group({required this.name, required this.sounds});

  ///Group Data from JSON Object
  factory Group.fromJSON(Map<String, dynamic> json) {
    return Group(
      name: json["name"] as String,
      sounds: json["sounds"],
    );
  }

  ///Group Data to JSON Object
  Map<String, dynamic> toJSON() {
    return {
      "name": name,
      "sounds": sounds,
    };
  }
}
