import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:imokay/pages/team/team.dart';
import 'package:imokay/util/notifications/local.dart';
import 'package:imokay/util/storage/local.dart';
import 'package:imokay/util/theming/color_handler.dart';
import 'package:imokay/util/theming/controller.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    //Default Colors
    Color accentColor = ColorHandler.hexToColor(
          LocalStorage.boxData(box: "preferences")["colors"]?["accent"],
        ) ??
        Theme.of(context).colorScheme.secondary;

    Color activeSoundColor = ColorHandler.hexToColor(
          LocalStorage.boxData(box: "preferences")["colors"]?["active_sound"],
        ) ??
        Theme.of(context).cardColor;

    //Default Volume
    double defaultVolume =
        LocalStorage.boxData(box: "preferences")["def_volume"] ?? 80.0;

    //Settings
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        title: Text(
          "Settings",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context, defaultVolume);
          },
          icon: const Icon(Ionicons.ios_chevron_back),
        ),
      ),
      body: SafeArea(
        child: SettingsList(
          physics: const BouncingScrollPhysics(),
          lightTheme: SettingsThemeData(
            settingsListBackground: Theme.of(context).scaffoldBackgroundColor,
          ),
          darkTheme: SettingsThemeData(
            settingsListBackground: Theme.of(context).scaffoldBackgroundColor,
          ),
          sections: [
            SettingsSection(
              title: const Text("UI & Visuals"),
              tiles: [
                //Theme Mode
                SettingsTile.switchTile(
                  leading: const Icon(
                    Ionicons.brush,
                  ),
                  initialValue: ThemeController.current(context: context),
                  onToggle: (mode) {
                    ThemeController().setTheme(context: context, mode: mode);
                  },
                  title: const Text("Theme Mode"),
                  description: ThemeController.current(context: context)
                      ? const Text("Dark Mode")
                      : const Text("Light Mode"),
                ),

                //Custom Colors
                SettingsTile.navigation(
                  leading: const Icon(
                    Ionicons.color_fill,
                  ),
                  title: const Text("Colors"),
                  onPressed: (context) async {
                    await showModalBottomSheet(
                      showDragHandle: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(14.0),
                        ),
                      ),
                      isScrollControlled: true,
                      context: context,
                      builder: (context) {
                        return SizedBox(
                          width: double.infinity,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Text(
                                  "Colors",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                  ),
                                ),
                              ),
                              StatefulBuilder(
                                builder: (context, update) {
                                  return ListTile(
                                    title: const Text("Accent"),
                                    trailing: Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: accentColor,
                                      ),
                                    ),
                                    onTap: () async {
                                      //Show Dialog
                                      await showColorPickerDialog(
                                        context,
                                        accentColor,
                                      ).then((newColor) async {
                                        //Update UI
                                        setState(() {
                                          accentColor = newColor;
                                        });

                                        update(() => {});

                                        //Update Colors Locally
                                        await LocalStorage.updateValue(
                                          box: "preferences",
                                          item: "colors",
                                          value: {
                                            "accent":
                                                ColorHandler.colorToHexString(
                                              accentColor,
                                            ),
                                            "active_sound":
                                                ColorHandler.colorToHexString(
                                              activeSoundColor,
                                            ),
                                          },
                                        );
                                      });
                                    },
                                  );
                                },
                              ),
                              StatefulBuilder(
                                builder: (context, update) {
                                  return ListTile(
                                    title: const Text("Sound Tiles"),
                                    trailing: Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: activeSoundColor,
                                      ),
                                    ),
                                    onTap: () async {
                                      //Show Dialog
                                      await showColorPickerDialog(
                                        context,
                                        activeSoundColor,
                                      ).then((newColor) async {
                                        //Update UI
                                        setState(() {
                                          activeSoundColor = newColor;
                                        });

                                        update(() => {});

                                        //Update Colors Locally
                                        await LocalStorage.updateValue(
                                          box: "preferences",
                                          item: "colors",
                                          value: {
                                            "accent":
                                                ColorHandler.colorToHexString(
                                              accentColor,
                                            ),
                                            "active_sound":
                                                ColorHandler.colorToHexString(
                                              activeSoundColor,
                                            ),
                                          },
                                        );
                                      });
                                    },
                                  );
                                },
                              ),
                              const SizedBox(height: 20.0),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),

                //Reset Theme
                SettingsTile.navigation(
                  leading: const Icon(Ionicons.reload),
                  title: const Text("Reset Theme"),
                  onPressed: (context) async {
                    //Reset Theme
                    await AdaptiveTheme.of(context).reset();

                    //Reset Colors
                    await LocalStorage.updateValue(
                      box: "preferences",
                      item: "colors",
                      value: {},
                    );

                    //Notify User
                    LocalNotifications.toast(message: "Theme Reset");
                  },
                ),
              ],
            ),

            //Sound Settings
            SettingsSection(
              title: const Text("Sounds"),
              tiles: [
                //Default Volume
                SettingsTile.navigation(
                  leading: const Icon(Ionicons.ios_volume_high),
                  title: const Text("Default Volume"),
                  onPressed: (context) async {
                    await showModalBottomSheet(
                      context: context,
                      showDragHandle: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(14.0),
                          topRight: Radius.circular(14.0),
                        ),
                      ),
                      builder: (context) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text(
                                "Volume",
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(40.0),
                              child: StatefulBuilder(
                                builder: (context, update) {
                                  return Column(
                                    children: [
                                      //Volume Slider
                                      Slider(
                                        min: 10.0,
                                        max: 100.0,
                                        value: defaultVolume,
                                        onChanged: (newVolume) async {
                                          update(() => {});

                                          setState(() {
                                            defaultVolume = newVolume;
                                          });

                                          //Update Volume
                                          await LocalStorage.updateValue(
                                            box: "preferences",
                                            item: "def_volume",
                                            value: newVolume,
                                          );
                                        },
                                      ),

                                      //Volume Percentage
                                      Text("${defaultVolume.floor()}%"),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),

            //Team & Licenses
            SettingsSection(
              title: const Text("Legal & More"),
              tiles: [
                //Team
                SettingsTile.navigation(
                  leading: const Icon(Ionicons.ios_people),
                  title: const Text("Team"),
                  description: const Text("The Team behind I'm Okay"),
                  onPressed: (context) => Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (context) => const Team()),
                  ),
                ),

                //Licenses
                SettingsTile.navigation(
                  leading: const Icon(Ionicons.ios_document),
                  title: const Text("Licenses"),
                  description: const Text(
                    "Licenses for Packages that make I'm Okay possible",
                  ),
                  onPressed: (context) => Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => LicensePage(
                        applicationIcon: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(14.0),
                            child: Image.asset(
                              "assets/logo.png",
                              height: 80.0,
                            ),
                          ),
                        ),
                        applicationName: "I'm Okay",
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
