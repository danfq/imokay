import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:imokay/util/sound/custom.dart';
import 'package:imokay/util/sound/favorite.dart';
import 'package:imokay/util/sound/manager.dart';
import 'package:imokay/util/storage/local.dart';
import 'package:imokay/util/theming/color_handler.dart';
import 'package:imokay/util/widgets/sounds.dart';
import 'package:just_audio/just_audio.dart';

///Sound Widget
class SoundItem extends StatefulWidget {
  const SoundItem({
    super.key,
    this.enabled = true,
    required this.data,
    required this.icon,
    required this.playing,
    this.extraInfo,
    this.padding = 0.0,
    this.showFavorite = true,
    required this.volume,
  });

  //Parameters
  final bool enabled;
  final SoundData data;
  final IconData icon;
  final bool playing;
  final String? extraInfo;
  final double padding;
  final bool showFavorite;
  final double volume;

  @override
  State<SoundItem> createState() => _SoundItemState();
}

class _SoundItemState extends State<SoundItem>
    with AutomaticKeepAliveClientMixin {
  bool playing = false;
  bool? favorite;
  bool looping = false;

  //Volume
  double volume =
      LocalStorage.boxData(box: "preferences")["def_volume"] ?? 80.0;

  //New Group Controller
  TextEditingController newGroupController = TextEditingController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    favorite = LocalStorage.boxData(box: "favorites")[widget.data.name];

    //Playing State
    playing = AudioPlayerManager.getPlayer(widget.data.name).playing;
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

    //Audio Player
    final audioPlayer = AudioPlayerManager.getPlayer(widget.data.name);

    //Audio Source
    AudioSource audioSource;

    //Check for Custom Sound
    if (widget.data.name != "custom") {
      audioSource = AudioSource.asset("assets/audio/${widget.data.name}.flac");
    } else {
      //Custom Sound Path
      final filePath = LocalStorage.boxData(box: "custom_sound")["path"];

      //Set Custom Sound Source
      audioSource = AudioSource.file(filePath);
    }

    //Set Volume
    await audioPlayer.setVolume(volume / 100);

    //Set Source
    await audioPlayer.setAudioSource(audioSource);

    //Play
    await audioPlayer.play();

    //Audio Stopped Listener
    audioPlayer.playerStateStream.listen((state) {
      if (mounted) {
        setState(() {
          playing = state.playing;
          // Stopped state handling
          if (state.processingState == ProcessingState.idle ||
              state.processingState == ProcessingState.completed) {
            playing = false;
            looping = false;
          }
        });
      }
    });

    //Audio Complete
    audioPlayer.processingStateStream.listen((state) {
      if (state == ProcessingState.completed) {
        if (mounted && !looping) {
          setState(() {
            playing = false;
          });
        }
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
                onLongPress: widget.enabled
                    ? () async {
                        //Show Volume Slider
                        await showModalBottomSheet(
                          context: context,
                          showDragHandle: true,
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
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(40.0),
                                  child: StatefulBuilder(
                                    builder: (context, update) {
                                      return Column(
                                        children: [
                                          //Volume Slider
                                          Slider(
                                            min: 10.0,
                                            max: 100.0,
                                            value: volume,
                                            onChanged: (newVolume) async {
                                              update(() => {});

                                              setState(() {
                                                volume = newVolume;
                                              });

                                              //Update Player Volume
                                              await AudioPlayerManager
                                                  .setPlayerVolume(
                                                playerID: widget.data.name,
                                                volume: volume,
                                              );
                                            },
                                          ),

                                          //Volume Percentage
                                          Text("${volume.floor()}%"),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    : null,
                onTap: widget.enabled
                    ? () async {
                        //Check for Custom Sound
                        if (widget.data.name == "custom") {
                          //Check if Custom Sound is Set
                          final data =
                              LocalStorage.boxData(box: "custom_sound");

                          if (data.isNotEmpty) {
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
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            widget.icon,
                            size: 60.0,
                          ),
                          widget.extraInfo != null
                              ? const SizedBox(height: 8.0)
                              : Container(),
                          widget.extraInfo != null
                              ? Text(widget.extraInfo!)
                              : Container(),
                        ],
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
                    ? ColorHandler.colorFromString(
                          LocalStorage.boxData(box: "preferences")["colors"]
                              ?["accent"],
                        ) ??
                        Theme.of(context).colorScheme.secondary
                    : Colors.grey,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
