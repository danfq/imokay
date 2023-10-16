import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:imokay/pages/zen/widgets/main.dart';
import 'package:metaballs/metaballs.dart';

class ZenMode extends StatefulWidget {
  const ZenMode({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ZenModeState();
}

class _ZenModeState extends State<ZenMode> {
  @override
  void initState() {
    super.initState();

    //Fullscreen
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  @override
  void dispose() {
    super.dispose();
  }

  //Content
  double scaffoldOpacity = 1.0;
  Widget zenMode = const ZenModeMainScreen();

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: scaffoldOpacity,
      duration: const Duration(seconds: 2),
      child: Scaffold(
        body: Container(
          color: Colors.black,
          child: Metaballs(
            color: Theme.of(context).colorScheme.secondary,
            child: Stack(
              children: [
                Positioned(
                  top: 40.0,
                  right: 20.0,
                  child: IconButton(
                    onPressed: () async {
                      //Show Learn More Bottom Sheet
                      await showModalBottomSheet(
                        context: context,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.0),
                        ),
                        builder: (context) {
                          return SizedBox(
                            width: double.infinity,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Text(
                                    "Zen Mode",
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: FutureBuilder(
                                    future: rootBundle.loadString(
                                      "assets/text/zen.txt",
                                    ),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.done) {
                                        return Text(
                                          snapshot.data!,
                                        );
                                      } else {
                                        return Container();
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    tooltip: "Learn More",
                    icon: const Icon(
                      Ionicons.information_circle,
                    ),
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Zen Mode",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26.0,
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            //Fade Out
                            scaffoldOpacity = 0.0;
                          });

                          //Change View
                          await Future.delayed(const Duration(seconds: 2), () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => zenMode,
                              ),
                            );
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).cardColor.withOpacity(0.6),
                        ),
                        child: const Icon(Ionicons.chevron_forward),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
