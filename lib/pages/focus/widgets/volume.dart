import 'package:flutter/material.dart';
import 'package:imokay/util/sound/manager.dart';

class FocusVolume extends StatefulWidget {
  const FocusVolume({super.key});

  @override
  State<FocusVolume> createState() => _FocusVolumeState();
}

class _FocusVolumeState extends State<FocusVolume> {
  ///Volume
  double _volume = 80.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        //Slider
        Slider(
          value: _volume / 100,
          onChanged: (value) async {
            setState(() {
              _volume = value * 100;
            });

            //Set Volume
            await AudioPlayerManager.setVolume(volume: _volume);
          },
        ),

        //Value
        Text(
          "${(_volume).ceil()}%",
          style: const TextStyle(fontSize: 18.0),
        ),
      ],
    );
  }
}
