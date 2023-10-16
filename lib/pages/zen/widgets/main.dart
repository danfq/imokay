import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:metaballs/metaballs.dart';

class ZenModeMainScreen extends StatefulWidget {
  const ZenModeMainScreen({super.key});

  @override
  State<ZenModeMainScreen> createState() => _ZenModeMainScreenState();
}

class _ZenModeMainScreenState extends State<ZenModeMainScreen> {
  //Content
  double scaffoldOpacity = 0.0;

  //Metaballs Properties
  Color ballsColor = Colors.white30;
  MetaballsEffect ballsEffect = MetaballsEffect.follow();

  //Set Opacity
  void setOpacity() async {
    await Future.delayed(const Duration(seconds: 0), () {
      setState(() {
        //Fade In
        scaffoldOpacity = 1.0;
      });
    });
  }

  @override
  void initState() {
    super.initState();

    setOpacity();

    //Fullscreen
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  @override
  void dispose() {
    //Restore Non-Fullscreen Mode
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: scaffoldOpacity,
      duration: const Duration(seconds: 2),
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              color: Colors.black,
              child: Metaballs(
                color: ballsColor,
                effect: ballsEffect,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Card(
                    color: Theme.of(context).cardColor.withOpacity(0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: () {},
                          style: IconButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14.0),
                            ),
                          ),
                          icon: Icon(
                            Ionicons.brush,
                            color: Theme.of(context).iconTheme.color,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          style: IconButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14.0),
                            ),
                          ),
                          icon: Icon(
                            Ionicons.volume_high,
                            color: Theme.of(context).iconTheme.color,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          style: IconButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14.0),
                            ),
                          ),
                          icon: Icon(
                            FontAwesome5Solid.exchange_alt,
                            color: Theme.of(context).iconTheme.color,
                          ),
                        ),
                      ],
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
