import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:imokay/util/models/groups.dart';
import 'package:imokay/util/models/sound_data.dart';
import 'package:imokay/util/notifications/local.dart';
import 'package:imokay/util/storage/local.dart';

class GroupsList extends StatefulWidget {
  const GroupsList({super.key, required this.sound});

  //Parameters
  final SoundData sound;

  @override
  State<GroupsList> createState() => _GroupsListState();
}

class _GroupsListState extends State<GroupsList> {
  //Groups
  late List<dynamic> groups;

  @override
  void initState() {
    super.initState();
    groups = LocalStorage.boxData(box: "groups")!
        .entries
        .map((element) => element.value)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return (groups.isNotEmpty)
        ? SizedBox(
            height: 180.0,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: groups.length,
              itemBuilder: (context, index) {
                //Group
                final group = groups[index] as Group;

                //Group Sounds
                final groupSounds = LocalStorage.boxData(
                  box: "groups",
                )![group.name]
                    .sounds as List<SoundData>;

                for (final groupSound in groupSounds) {
                  print(groupSound.name);
                }

                print("SOUND TO ADD => ${widget.sound.name}");

                //Group Item
                return ListTile(
                  leading: Icon(
                    Ionicons.grid_outline,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  title: Text(group.name),
                  onTap: () async {
                    //Check if Sound is Already Added
                    bool isSoundAlreadyAdded(SoundData sound) {
                      return groupSounds.any(
                        (existingSound) => existingSound.name == sound.name,
                      );
                    }

                    if (!isSoundAlreadyAdded(widget.sound)) {
                      groupSounds.add(
                        SoundData(
                          name: widget.sound.name,
                          isFavorite: widget.sound.isFavorite,
                        ),
                      );

                      //Add Sound to Group
                      await LocalStorage.setData(
                        box: "groups",
                        data: {
                          group.name: Group.fromJSON(
                            {
                              "name": group.name,
                              "sounds": groupSounds,
                            },
                          ),
                        },
                      );

                      LocalNotifications.toast(message: "Sound Added to Group");
                    }

                    if (mounted) {
                      Navigator.pop(
                        context,
                      );
                    }
                  },
                );
              },
            ),
          )
        : const Center(
            child: Text("No Groups"),
          );
  }
}
