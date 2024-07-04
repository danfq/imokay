import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:imokay/util/sound/all.dart';
import 'package:imokay/util/storage/local.dart';
import 'package:imokay/util/theming/color_handler.dart';
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
  MainUISounds({super.key, required this.soundKeys, required this.volume});

  //Sound Keys
  final List<GlobalKey> soundKeys;

  //Volume
  final double volume;

  //Page Controller
  final MainUISoundsController _soundsController = Get.put(
    MainUISoundsController(),
  );
  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          //Page Indicator
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SmoothPageIndicator(
              controller: _pageController,
              effect: SwapEffect(
                activeDotColor: ColorHandler.hexToColor(
                      LocalStorage.boxData(
                        box: "preferences",
                      )["colors"]?["accent"],
                    ) ??
                    Theme.of(context).colorScheme.secondary,
                dotHeight: 12.0,
                dotWidth: 12.0,
              ),
              count: 3,
            ),
          ),

          //Sounds
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
                    volume: volume,
                    soundData: [
                      SoundData(name: "thunder", extraInfo: "Thunder"),
                      SoundData(name: "wind", extraInfo: "Wind"),
                      SoundData(name: "birds", extraInfo: "Birds"),
                      SoundData(name: "waves", extraInfo: "Waves"),
                    ],
                  ),
                  _buildSoundGrid(
                    context,
                    volume: volume,
                    soundData: [
                      SoundData(name: "fireplace", extraInfo: "Fireplace"),
                      SoundData(name: "vacuum", extraInfo: "Vacuum"),
                      SoundData(name: "talking", extraInfo: "People Talking"),
                      SoundData(name: "tv_static", extraInfo: "TV Static"),
                    ],
                  ),
                  _buildSoundGrid(
                    context,
                    volume: volume,
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
                  _soundsController.setPage(page);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Simplified Sound Grid
  Widget _buildSoundGrid(
    BuildContext context, {
    required List<SoundData> soundData,
    required double volume,
  }) {
    //Calculate Columns based on Screen Width
    double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = (screenWidth / 150).floor();

    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(10.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
        childAspectRatio: 1.0,
      ),
      itemCount: soundData.length,
      itemBuilder: (context, index) {
        final data = soundData[index];
        return Obx(
          () => SoundItem(
            playing: _soundsController.audioPlaying.value,
            icon: soundIcons[data.name]!,
            data: data,
            extraInfo: data.extraInfo,
            enabled: data.enabled,
            volume: volume,
          ),
        );
      },
    );
  }
}

/// Sound Data
class SoundData {
  final String name;
  final String? extraInfo;
  final bool enabled;

  SoundData({required this.name, this.extraInfo, this.enabled = true});
}
