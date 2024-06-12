import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:imokay/pages/team/team.dart';
import 'package:imokay/util/notifications/local.dart';
import 'package:imokay/util/storage/local.dart';
import 'package:imokay/util/theming/color_handler.dart';
import 'package:imokay/util/theming/controller.dart';
import 'package:imokay/util/theming/themes.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    // Default Colors
    Color accentColor = ColorHandler.colorFromString(
          LocalStorage.boxData(box: "preferences")["colors"]?["accent"],
        ) ??
        Theme.of(context).colorScheme.secondary;

    Color favoritesColor = ColorHandler.colorFromString(
          LocalStorage.boxData(box: "preferences")["colors"]?["favorites"],
        ) ??
        Theme.of(context).colorScheme.secondary;

    Color activeSoundColor = ColorHandler.colorFromString(
          LocalStorage.boxData(box: "preferences")["colors"]?["active_sound"],
        ) ??
        Theme.of(context).cardColor;

    // Settings
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
            Get.back();
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
                // Theme Mode
                SettingsTile.switchTile(
                  leading: const Icon(Ionicons.brush),
                  initialValue: ThemeController.current(context: context),
                  onToggle: (mode) {
                    ThemeController().setTheme(context: context, mode: mode);
                  },
                  title: const Text("Theme Mode"),
                  description: ThemeController.current(context: context)
                      ? const Text("Dark Mode")
                      : const Text("Light Mode"),
                ),

                // Custom Colors
                SettingsTile.navigation(
                  leading: const Icon(Ionicons.color_fill),
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
                              _buildColorPickerTile(
                                context,
                                "Accent",
                                accentColor,
                                (newColor) {
                                  setState(() {
                                    accentColor = newColor;
                                  });
                                  _saveColors(
                                    accentColor,
                                    favoritesColor,
                                    activeSoundColor,
                                  );
                                },
                              ),
                              _buildColorPickerTile(
                                context,
                                "Favorites",
                                favoritesColor,
                                (newColor) {
                                  setState(() {
                                    favoritesColor = newColor;
                                  });
                                  _saveColors(
                                    accentColor,
                                    favoritesColor,
                                    activeSoundColor,
                                  );
                                },
                              ),
                              _buildColorPickerTile(
                                context,
                                "Sound Tiles",
                                activeSoundColor,
                                (newColor) {
                                  setState(() {
                                    activeSoundColor = newColor;
                                  });
                                  _saveColors(
                                    accentColor,
                                    favoritesColor,
                                    activeSoundColor,
                                  );
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Close Bottom Sheet
                                    Get.back();

                                    // Save New Theme
                                    AdaptiveTheme.of(context).setTheme(
                                      light: Themes.light().copyWith(
                                        colorScheme:
                                            Themes.light().colorScheme.copyWith(
                                                  secondary: accentColor,
                                                ),
                                        cardColor: activeSoundColor,
                                      ),
                                      dark: Themes.dark().copyWith(
                                        colorScheme:
                                            Themes.dark().colorScheme.copyWith(
                                                  secondary: accentColor,
                                                ),
                                        cardColor: activeSoundColor,
                                      ),
                                    );

                                    LocalNotifications.toast(
                                      message: "New Theme Saved",
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).dialogBackgroundColor,
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text("Save Theme"),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),

                // Reset Theme
                SettingsTile.navigation(
                  leading: const Icon(Ionicons.reload),
                  title: const Text("Reset Theme"),
                  onPressed: (context) async {
                    // Reset Theme
                    await AdaptiveTheme.of(context).reset();

                    // Reset Colors
                    await LocalStorage.updateValue(
                      box: "preferences",
                      item: "colors",
                      value: {},
                    );

                    // Notify User
                    LocalNotifications.toast(message: "Theme Reset");
                  },
                ),
              ],
            ),

            // Team & Licenses
            SettingsSection(
              title: const Text("Legal & More"),
              tiles: [
                // Team
                SettingsTile.navigation(
                  leading: const Icon(Ionicons.ios_people),
                  title: const Text("Team"),
                  description: const Text("The Team behind I'm Okay"),
                  onPressed: (context) => Get.to(() => const Team()),
                ),

                // Licenses
                SettingsTile.navigation(
                  leading: const Icon(Ionicons.ios_document),
                  title: const Text("Licenses"),
                  description: const Text(
                    "Licenses for Packages that make I'm Okay possible",
                  ),
                  onPressed: (context) => Get.to(
                    () => LicensePage(
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
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorPickerTile(
    BuildContext context,
    String title,
    Color color,
    ValueChanged<Color> onColorChanged,
  ) {
    return StatefulBuilder(
      builder: (context, update) {
        return ListTile(
          title: Text(title),
          trailing: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
          ),
          onTap: () async {
            Color? newColor = await showColorPickerDialog(context, color);
            onColorChanged(newColor);
            update(() {});
          },
        );
      },
    );
  }

  Future<void> _saveColors(
    Color accentColor,
    Color favoritesColor,
    Color activeSoundColor,
  ) async {
    await LocalStorage.updateValue(
      box: "preferences",
      item: "colors",
      value: {
        "accent": accentColor.toString(),
        "favorites": favoritesColor.toString(),
        "active_sound": activeSoundColor.toString(),
      },
    );
  }
}
