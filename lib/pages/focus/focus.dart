import 'package:flutter/material.dart';
import 'package:imokay/pages/focus/widgets/breathe.dart';
import 'package:imokay/pages/focus/widgets/dot.dart';
import 'package:imokay/pages/focus/widgets/volume.dart';
import 'package:imokay/util/sound/manager.dart';

class FocusMode extends StatefulWidget {
  const FocusMode({Key? key}) : super(key: key);

  @override
  State<FocusMode> createState() => _FocusModeState();
}

class _FocusModeState extends State<FocusMode> {
  @override
  void initState() {
    super.initState();

    //Start Focus Mode
    AudioPlayerManager.setFocusMode(mode: true);
  }

  @override
  void dispose() {
    //Stop Focus Mode
    AudioPlayerManager.setFocusMode(mode: false);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Focus Mode")),
      body: const SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Breathing
            FocusBreathe(),

            //Spacing
            SizedBox(height: 20.0),

            //Dot
            Center(
              child: SizedBox(
                width: 400,
                height: 400,
                child: FocusDot(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const Padding(
        padding: EdgeInsets.all(20.0),
        child: FocusVolume(),
      ),
    );
  }
}
