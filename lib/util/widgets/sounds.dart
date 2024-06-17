import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:imokay/util/sound/all.dart';
import 'package:imokay/util/theming/controller.dart';
import 'package:imokay/util/timer/handler.dart';
import 'package:imokay/util/widgets/sound_item.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

// Controller for handling state
class MainUISoundsController extends GetxController {
  var currentSet = 0.obs;
  var audioPlaying = false.obs;

  // Method to change the current page
  void setPage(int page) {
    currentSet.value = page;
  }
}

class MainUISounds extends StatelessWidget {
  MainUISounds({super.key, required this.soundKeys});

  //Sound Keys
  final List<GlobalKey> soundKeys;

  final MainUISoundsController controller = Get.put(MainUISoundsController());
  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: PageStorage(
              bucket: PageStorageBucket(),
              child: PageView(
                controller: _pageController,
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                children: [
                  _buildSoundGrid(
                    context,
                    soundData: [
                      SoundData(name: "thunder"),
                      SoundData(name: "wind"),
                      SoundData(name: "birds"),
                      SoundData(name: "waves"),
                    ],
                  ),
                  _buildSoundGrid(
                    context,
                    soundData: [
                      SoundData(name: "fireplace"),
                      SoundData(name: "vacuum"),
                      SoundData(name: "talking"),
                      SoundData(name: "tv_static"),
                    ],
                  ),
                  _buildSoundGrid(
                    context,
                    soundData: [
                      SoundData(name: "brown_noise", extraInfo: "Brown Noise"),
                      SoundData(name: "white_noise", extraInfo: "White Noise"),
                      SoundData(name: "green_noise", extraInfo: "Green Noise"),
                      SoundData(
                        name: "custom",
                        extraInfo: "Custom Sound",
                        enabled: !Platform.isIOS,
                      ),
                    ],
                  ),
                ],
                onPageChanged: (page) {
                  controller.setPage(page);
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Obx(() => AnimatedSmoothIndicator(
                  activeIndex: controller.currentSet.value,
                  count: 3,
                  effect: ExpandingDotsEffect(
                    activeDotColor: ThemeController.current(context: context)
                        ? Theme.of(context).iconTheme.color!
                        : Colors.black,
                    dotWidth: 10.0,
                    dotHeight: 10.0,
                  ),
                )),
          ),
        ],
      ),
    );
  }

  ///Sound Grid
  Widget _buildSoundGrid(
    BuildContext context, {
    required List<SoundData> soundData,
  }) {
    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: soundData.length,
      itemBuilder: (context, index) {
        final data = soundData[index];
        return Obx(
          () => SoundItem(
            playing: controller.audioPlaying.value,
            icon: soundIcons[data.name]!,
            data: data,
            extraInfo: data.extraInfo,
            enabled: data.enabled,
          ),
        );
      },
    );
  }
}

///Sound Data
class SoundData {
  final String name;
  final String? extraInfo;
  final bool enabled;

  SoundData({required this.name, this.extraInfo, this.enabled = true});
}
