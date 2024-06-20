import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:imokay/pages/favorites/favorites.dart';
import 'package:imokay/pages/focus/focus.dart';
import 'package:imokay/pages/settings/settings.dart';
import 'package:imokay/pages/sounds/sounds.dart';
import 'package:imokay/util/constants/text.dart';
import 'package:imokay/util/theming/controller.dart';
import 'package:imokay/util/timer/handler.dart';

class Home extends StatelessWidget {
  Home({super.key});

  //Inject Theme Controller
  final ThemeController themeController = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    //Immersion
    themeController.immersion(context: context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: const Text("I'm Okay"),
        leading: IconButton(
          icon: const Icon(Ionicons.ios_heart_outline),
          tooltip: "Favorites",
          onPressed: () {
            Get.to(() => const Favorites());
          },
        ),
        actions: [
          //Timer
          IconButton(
            icon: const Icon(Ionicons.ios_timer_outline),
            tooltip: "Timer",
            onPressed: () async {
              await TimerHandler.showTimerSheet();
            },
          ),

          //Settings
          IconButton(
            icon: Icon(
              Ionicons.ios_settings_outline,
              color: Theme.of(context).iconTheme.color,
            ),
            tooltip: "Settings",
            onPressed: () async {
              await Get.to(() => const SettingsPage());
            },
          ),
        ],
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: const SafeArea(
        child: SoundsPage(),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 40.0),
        child: ElevatedButton.icon(
          onPressed: () async {
            //Confirmation
            bool confirmed = await Get.dialog<bool>(
                  AlertDialog(
                    title: const Text("Focus Mode"),
                    content: const Text(TextConstants.focusModeDesc),
                    actions: [
                      TextButton(
                        onPressed: () => Get.back(result: true),
                        child: const Text("Start"),
                      ),
                      TextButton(
                        onPressed: () => Get.back(result: false),
                        child: const Text("Cancel"),
                      ),
                    ],
                  ),
                ) ??
                false;

            if (confirmed) {
              Get.to(() => const FocusMode());
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).dialogBackgroundColor,
          ),
          icon: const Icon(MaterialCommunityIcons.meditation),
          label: const Text("Focus Mode"),
        ),
      ),
    );
  }
}
