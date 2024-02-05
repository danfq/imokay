import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:imokay/pages/favorites/favorites.dart';
import 'package:imokay/pages/focus/focus.dart';
import 'package:imokay/pages/settings/settings.dart';
import 'package:imokay/pages/sounds/sounds.dart';
import 'package:imokay/util/constants/text.dart';
import 'package:imokay/util/theming/controller.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    //Immersion
    ThemeController.immersion(context: context);
  }

  //Audio
  bool audioPlaying = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: const Text("I'm Okay"),
        leading: IconButton(
          icon: const Icon(Ionicons.ios_heart_outline),
          tooltip: "Favorites",
          onPressed: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => const Favorites(),
              ),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Ionicons.ios_settings_outline,
              color: Theme.of(context).iconTheme.color,
            ),
            tooltip: "Settings",
            onPressed: () async {
              await Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => const SettingsPage(),
                ),
              );
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
        padding: const EdgeInsets.all(40.0),
        child: ElevatedButton.icon(
          onPressed: () async {
            //Confirmation
            final confirmed = await confirm(
              context,
              title: const Text("Focus Mode"),
              content: const Text(TextConstants.focusModeDesc),
              textOK: const Text("Start"),
            );

            //Check Confirmation
            if (confirmed) {
              //Go into Focus Mode
              if (mounted) {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => const FocusMode(),
                  ),
                );
              }
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
