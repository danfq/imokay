import 'dart:io';
import 'package:flutter/material.dart';
import 'package:imokay/util/models/sound_data.dart';
import 'package:imokay/util/sound/all.dart';
import 'package:imokay/util/theming/controller.dart';
import 'package:imokay/util/widgets/sound_item.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

///Main UI Sounds
class MainUISounds extends StatefulWidget {
  const MainUISounds({super.key, required this.soundKeys});

  //Sound Keys
  final List<GlobalKey> soundKeys;

  @override
  State<MainUISounds> createState() => _MainUISoundsState();
}

class _MainUISoundsState extends State<MainUISounds>
    with AutomaticKeepAliveClientMixin {
  //Timer
  Duration timerDuration = const Duration(minutes: 5);
  bool timerInProgress = false;
  bool audioPlaying = false;

  //Paging
  final PageController _setController = PageController(initialPage: 0);
  int currentSet = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: PageStorage(
              bucket: PageStorageBucket(),
              child: PageView(
                controller: _setController,
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                children: [
                  GridView.count(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    childAspectRatio: 1,
                    crossAxisCount: 2,
                    crossAxisSpacing: 0.5,
                    mainAxisSpacing: 0.5,
                    children: [
                      SoundItem(
                        playing: audioPlaying,
                        icon: soundIcons["thunder"]!,
                        data: SoundData(
                          name: "thunder",
                        ),
                      ),
                      SoundItem(
                        playing: audioPlaying,
                        icon: soundIcons["wind"]!,
                        data: SoundData(
                          name: "wind",
                        ),
                      ),
                      SoundItem(
                        playing: audioPlaying,
                        icon: soundIcons["birds"]!,
                        data: SoundData(
                          name: "birds",
                        ),
                      ),
                      SoundItem(
                        playing: audioPlaying,
                        icon: soundIcons["waves"]!,
                        data: SoundData(
                          name: "waves",
                        ),
                      ),
                    ],
                  ),
                  GridView.count(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    childAspectRatio: 1,
                    crossAxisCount: 2,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                    children: [
                      SoundItem(
                        playing: audioPlaying,
                        icon: soundIcons["fireplace"]!,
                        data: SoundData(
                          name: "fireplace",
                        ),
                      ),
                      SoundItem(
                        playing: audioPlaying,
                        icon: soundIcons["vacuum"]!,
                        data: SoundData(
                          name: "vacuum",
                        ),
                      ),
                      SoundItem(
                        playing: audioPlaying,
                        icon: soundIcons["talking"]!,
                        data: SoundData(
                          name: "talking",
                        ),
                      ),
                      SoundItem(
                        playing: audioPlaying,
                        icon: soundIcons["tv_static"]!,
                        data: SoundData(
                          name: "tv_static",
                        ),
                      ),
                    ],
                  ),
                  GridView.count(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    childAspectRatio: 1,
                    crossAxisCount: 2,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                    children: [
                      SoundItem(
                        playing: audioPlaying,
                        icon: soundIcons["brown_noise"]!,
                        extraInfo: "Brown Noise",
                        data: SoundData(
                          name: "brown_noise",
                        ),
                      ),
                      SoundItem(
                        playing: audioPlaying,
                        icon: soundIcons["white_noise"]!,
                        extraInfo: "White Noise",
                        data: SoundData(
                          name: "white_noise",
                        ),
                      ),
                      SoundItem(
                        playing: audioPlaying,
                        icon: soundIcons["green_noise"]!,
                        extraInfo: "Green Noise",
                        data: SoundData(
                          name: "green_noise",
                        ),
                      ),
                      SoundItem(
                        enabled: !Platform.isIOS,
                        playing: audioPlaying,
                        icon: soundIcons["custom"]!,
                        extraInfo: "Custom Sound",
                        data: SoundData(
                          name: "custom",
                        ),
                      ),
                    ],
                  ),
                ],
                onPageChanged: (page) {
                  setState(() {
                    currentSet = page;
                  });
                },
              ),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          AnimatedSmoothIndicator(
            activeIndex: currentSet,
            count: 3,
            effect: ExpandingDotsEffect(
              activeDotColor: ThemeController.current(context: context)
                  ? Theme.of(context).cardColor
                  : Colors.black,
              dotWidth: 10.0,
              dotHeight: 10.0,
            ),
          ),
        ],
      ),
    );
  }
}
