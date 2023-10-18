import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:imokay/pages/favorites/favorites.dart';
import 'package:imokay/pages/settings/settings.dart';
import 'package:imokay/pages/sounds/sounds.dart';
import 'package:imokay/util/notifications/local.dart';
import 'package:imokay/util/sound/manager.dart';
import 'package:imokay/util/sound/timer.dart';
import 'package:imokay/util/theming/controller.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //Navigation
  int currentIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    //Immersion
    ThemeController.immersion(context: context);
  }

  //Audio
  Duration timerDuration = const Duration(minutes: 5);
  bool timerInProgress = false;
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
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(
              width: 2.0,
              color: timerInProgress
                  ? Theme.of(context).colorScheme.secondary
                  : Colors.transparent,
            ),
          ),
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.0),
              ),
              padding: const EdgeInsets.all(20.0),
            ),
            icon: const Icon(Ionicons.ios_time),
            onPressed: () async {
              //Check if Timer is Active
              if (!timerInProgress) {
                //Show Timer Sheet
                await showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(14.0),
                    ),
                  ),
                  isScrollControlled: true,
                  builder: (context) {
                    //Readable Time
                    final readableTime = "${timerDuration.inMinutes} Minutes";

                    return StatefulBuilder(
                      builder: (context, setInside) {
                        return SizedBox(
                          width: double.infinity,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Text(
                                  "Timer",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Card(
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(14.0),
                                    ),
                                  ),
                                  child: ListTile(
                                    title: const Text("Duration"),
                                    trailing: Text(
                                      readableTime,
                                    ),
                                    onTap: () async {
                                      await showDialog(
                                        context: context,
                                        builder: (context) {
                                          return Dialog(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Padding(
                                                  padding: EdgeInsets.all(
                                                    20.0,
                                                  ),
                                                  child: Text(
                                                    "Set Timer Duration",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20.0,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                    20.0,
                                                  ),
                                                  child: TimerPicker(
                                                    initialDurationInMinutes:
                                                        timerDuration.inMinutes,
                                                    onDurationChanged:
                                                        (duration) {
                                                      setInside(() {
                                                        timerDuration =
                                                            duration;
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      //Timer Status
                                      setState(() {
                                        timerInProgress = true;
                                      });

                                      Future.delayed(timerDuration, () {
                                        setState(() {
                                          timerInProgress = false;
                                          audioPlaying = false;
                                        });
                                      });

                                      //Close Sheet
                                      Navigator.pop(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Theme.of(
                                        context,
                                      ).cardColor,
                                    ),
                                    child: const Text("Set Timer"),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              } else {
                await showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Timer Active"),
                      content: const Text(
                        "A Timer is already active.\n\nWould you like to cancel it?",
                      ),
                      actions: [
                        Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  //Close Dialog
                                  Navigator.pop(context);

                                  //Cancel Active Timer
                                  setState(() {
                                    timerInProgress = false;
                                  });

                                  //Stop All AudioPlayers
                                  AudioPlayerManager.stopAllPlayers();

                                  //Notify User
                                  LocalNotifications.toast(
                                    message: "Timer Cancelled",
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context).cardColor,
                                ),
                                child: const Text(
                                  "Cancel Active Timer",
                                ),
                              ),
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  //Do Nothing - Close Dialog
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context).cardColor,
                                ),
                                child: const Text(
                                  "Proceed with Current Timer",
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                );
              }
            },
            label: timerInProgress
                ? CountdownTimer(duration: timerDuration)
                : const Text(
                    "Timer",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
