import 'package:file_picker/file_picker.dart';
import 'package:imokay/util/notifications/local.dart';
import 'package:imokay/util/storage/local.dart';

///Custom Sound Handling
class CustomSound {
  ///Select Custom Sound File
  static Future<void> chooseFile() async {
    //File
    final result = await FilePicker.platform.pickFiles(
      dialogTitle: "Custom Sound",
      type: FileType.audio,
    );

    //Confirm File
    if (result != null) {
      //Set Custom Audio File
      await LocalStorage.setData(
        box: "custom_sound",
        data: {
          "path": result.files.single.path,
        },
      ).then(
        (_) => LocalNotifications.toast(message: "Added Custom Sound"),
      );
    }
  }
}
