import 'package:hive_flutter/adapters.dart';
part 'sound_data.g.dart';

///Sound Data
@HiveType(typeId: 1)
class SoundData {
  @HiveField(0)
  final String name;

  @HiveField(1)
  bool isFavorite;

  SoundData({
    required this.name,
    this.isFavorite = false,
  });
}
