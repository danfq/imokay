import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:imokay/util/models/sound_data.dart';
import 'package:imokay/util/sound/custom.dart';
import 'package:imokay/util/sound/favorite.dart';
import 'package:imokay/util/sound/manager.dart';
import 'package:imokay/util/storage/local.dart';
import 'package:slider_controller/slider_controller.dart';

///Sound Widget
class SoundItem extends StatefulWidget {
  const SoundItem({
    super.key,
    this.enabled = true,
    required this.data,
    required this.icon,
    required this.playing,
    this.padding = 0.0,
    this.showFavorite = true,
  });

  //Parameters
  final bool enabled;
  final SoundData data;
  final IconData icon;
  final bool playing;
  final double padding;
  final bool showFavorite;

  @override
  State<SoundItem> createState() => _SoundItemState();
}

class _SoundItemState extends State<SoundItem>
    with AutomaticKeepAliveClientMixin {
  bool playing = false;
  bool? favorite;
  bool looping = false;

  //Volume
  double volume = 80.0;

  //New Group Controller
  TextEditingController newGroupController = TextEditingController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    favorite = LocalStorage.boxData(box: "favorites")![widget.data.name];

    //Playing State
    playing = AudioPlayerManager.getPlayer(widget.data.name).state ==
        PlayerState.playing;
  }

  ///Play Audio based on `name`
  void playAudio({
    required String name,
  }) async {
    if (mounted) {
      setState(() {
        playing = true;
      });
    }

    final audioPlayer = AudioPlayerManager.getPlayer(widget.data.name);
    final audioSource = (widget.data.name != "custom")
        ? AssetSource("audio/${widget.data.name}.flac")
        : BytesSource(
            File(
              LocalStorage.boxData(box: "custom_sound")!["path"],
            ).readAsBytesSync(),
          );

    //Set Volume
    await audioPlayer.setVolume(volume / 100).then((_) async {
      //Play Audio
      await audioPlayer.play(audioSource);
    });

    //Audio Stopped Listener
    audioPlayer.onPlayerStateChanged.listen((state) {
      if (state == PlayerState.stopped) {
        if (mounted) {
          setState(() {
            playing = false;
            looping = false;
          });
        }
      }
    });

    //Audio Complete
    audioPlayer.onPlayerComplete.listen((_) {
      if (mounted && !looping) {
        setState(() {
          playing = false;
        });
      }
    });
  }

  ///Stop Audio
  void stopAudio() async {
    final audioPlayer = AudioPlayerManager.getPlayer(widget.data.name);
    await audioPlayer.stop();

    if (mounted) {
      setState(() {
        playing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Stack(
      children: [
        //Item
        Opacity(
          opacity: widget.enabled ? 1.0 : 0.6,
          child: SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: InkWell(
                onLongPress: () async {
                  //Show Volume Slider
                  await showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(14.0),
                        topRight: Radius.circular(14.0),
                      ),
                    ),
                    builder: (context) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              "Volume",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(40.0),
                            child: SliderController(
                              sliderDecoration: SliderDecoration(
                                activeColor:
                                    Theme.of(context).colorScheme.secondary,
                              ),
                              value: volume,
                              onChanged: (newVolume) async {
                                setState(() {
                                  volume = newVolume;
                                });

                                //Set Player Volume
                                await AudioPlayerManager.setPlayerVolume(
                                  playerID: widget.data.name,
                                  volume: volume,
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                onTap: widget.enabled
                    ? () async {
                        //Check for Custom Sound
                        if (widget.data.name == "custom") {
                          //Check if Custom Sound is Set
                          final data =
                              LocalStorage.boxData(box: "custom_sound");

                          if (data != null && data.isNotEmpty) {
                            if (mounted) {
                              setState(() {
                                playing = !playing;
                              });
                            }

                            //Play or Stop Audio
                            if (playing) {
                              playAudio(name: widget.data.name);
                            } else {
                              stopAudio();

                              if (mounted) {
                                setState(() {
                                  looping = false;
                                });
                              }
                            }
                          } else {
                            //Request Custom Sound
                            await CustomSound.chooseFile();
                          }
                        } else {
                          if (mounted) {
                            setState(() {
                              playing = !playing;
                            });
                          }

                          //Play or Stop Audio
                          if (playing) {
                            playAudio(name: widget.data.name);
                          } else {
                            stopAudio();
                            if (mounted) {
                              setState(() {
                                looping = false;
                              });
                            }
                          }
                        }
                      }
                    : null,
                borderRadius: BorderRadius.circular(14.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.0),
                  ),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14.0),
                      color: !playing
                          ? widget.enabled
                              ? Theme.of(context).cardColor
                              : Theme.of(context).cardColor.withOpacity(0.2)
                          : Theme.of(context).cardColor.withOpacity(0.1),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(widget.padding),
                      child: Icon(
                        widget.icon,
                        size: 60.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),

        //Repeat
        Visibility(
          visible: widget.enabled,
          child: Positioned(
            top: 10.0,
            left: 20.0,
            child: IconButton(
              onPressed: () async {
                //Set Loop
                setState(() {
                  looping = !looping;
                });

                AudioPlayerManager.updateLoopStatus(
                  widget.data.name,
                  looping,
                );
              },
              icon: Icon(
                Ionicons.ios_repeat,
                color: looping
                    ? Theme.of(context).colorScheme.secondary
                    : Colors.grey,
              ),
            ),
          ),
        ),

        //Favorite
        Visibility(
          visible: widget.enabled && widget.showFavorite,
          child: Positioned(
            top: 10.0,
            right: 20.0,
            child: IconButton(
              onPressed: () async {
                //Set Favorite Status
                setState(() {
                  favorite = !(favorite ?? false);
                });

                await FavoriteSounds.update(
                  soundName: widget.data.name,
                  status: favorite ?? false,
                );
              },
              icon: Icon(
                Ionicons.ios_heart,
                color: (favorite ?? false)
                    ? Theme.of(context).colorScheme.secondary
                    : Colors.grey,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
