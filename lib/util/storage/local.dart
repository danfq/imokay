import 'package:hive_flutter/adapters.dart';
import 'package:imokay/util/models/groups.dart';
import 'package:imokay/util/models/sound_data.dart';
import 'package:imokay/util/sound/all.dart';
import 'package:path_provider/path_provider.dart';

///Local Storage
class LocalStorage {
  ///Hive Boxes
  static final _boxes = <String>[
    "favorites",
    "sounds",
    "playing",
    "preferences",
    "incentives",
    "custom_sound",
    "groups",
    "app_bar",
  ];

  ///Initialize Hive Storage
  static Future<void> init() async {
    //App Data Directory
    final appDataDir = await getApplicationDocumentsDirectory();

    //Local Path
    final localPath = "${appDataDir.path}/data";

    //Initialize Hive
    Hive.init(localPath);

    //Open Boxes
    await openBoxes();
  }

  ///Open Hive Boxes
  static Future<void> openBoxes() async {
    //Register Adapters
    registerAdapters();

    for (final box in _boxes) {
      await Hive.openBox(box);
    }
  }

  ///Register Adapters
  static void registerAdapters() {
    //SoundData Adapter
    Hive.registerAdapter(SoundDataAdapter());

    //Group Adapter
    Hive.registerAdapter(GroupAdapter());
  }

  ///Update Value
  static Future<void> updateValue({
    required String box,
    required int item,
    required dynamic value,
  }) async {
    //Box
    final localBox = Hive.box(box);

    //Update Value
    await localBox.putAll({
      sounds.entries.elementAt(item).value: !value,
    });
  }

  ///Set Data
  static Future<void> setData({
    required String box,
    required Map<String, dynamic> data,
  }) async {
    //Box
    final localBox = Hive.box(box);

    //Update Value
    await localBox.putAll(data);
  }

  ///Get Box Data
  static Map<dynamic, dynamic>? boxData({required String box}) {
    //Box
    final localBox = Hive.box(box);

    //Return Data as Map
    return localBox.toMap();
  }
}
