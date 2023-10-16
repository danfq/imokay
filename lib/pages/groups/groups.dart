import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:imokay/util/models/groups.dart';
import 'package:imokay/util/models/sound_data.dart';
import 'package:imokay/util/notifications/local.dart';
import 'package:imokay/util/sound/all.dart';
import 'package:imokay/util/storage/local.dart';
import 'package:imokay/util/widgets/animations.dart';
import 'package:imokay/util/widgets/sound_item.dart';

class Groups extends StatefulWidget {
  const Groups({super.key});

  @override
  State<Groups> createState() => _GroupsState();
}

class _GroupsState extends State<Groups> {
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
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        title: Text(
          "Groups",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Feather.chevron_left,
            color: Theme.of(context).iconTheme.color,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: groups.isEmpty
            ? Center(
                child: AnimationsHandler.asset(
                  name: "empty",
                  repeat: true,
                ),
              )
            : ListView.builder(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: groups.length,
                itemBuilder: (BuildContext context, int index) {
                  //Group
                  final group = groups[index] as Group;

                  final groupSounds = LocalStorage.boxData(
                    box: "groups",
                  )![group.name]
                      .sounds as List<SoundData>;

                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14.0),
                        child: ExpansionTile(
                          title: Text(group.name),
                          children: [
                            SizedBox(
                              height: 250.0,
                              child: AnimatedList(
                                physics: const BouncingScrollPhysics(),
                                initialItemCount: groupSounds.length,
                                itemBuilder: (context, index, animation) {
                                  return InkWell(
                                    onLongPress: () async {
                                      //Confirm Removal
                                      final confirmation = await confirm(
                                        context,
                                        title: const Text("Remove From Group"),
                                        content: Text(
                                          "Remove '${groupSounds[index].name}' from this Group?",
                                        ),
                                        textCancel: const Text("Cancel"),
                                        textOK: const Text("Remove"),
                                      );

                                      if (confirmation) {
                                        // Remove the Sound from the groupSounds list
                                        groupSounds.removeAt(index);

                                        groupSounds.removeWhere((sound) =>
                                            sound.name ==
                                            groupSounds[index].name);

                                        // Remove the Sound from the AnimatedList
                                        builder(context, animation) {
                                          return SlideTransition(
                                            position: animation.drive(
                                              Tween<Offset>(
                                                begin: const Offset(1, 0),
                                                end: const Offset(0, 0),
                                              ),
                                            ),
                                            child: Container(),
                                          );
                                        }

                                        if (mounted) {
                                          AnimatedList.of(context).removeItem(
                                            index,
                                            builder,
                                          );
                                        }

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

                                        LocalNotifications.toast(
                                          message: "Sound Removed from Group",
                                        );
                                      }
                                    },
                                    child: SoundItem(
                                      padding: 10.0,
                                      data: groupSounds[index],
                                      icon:
                                          soundIcons[groupSounds[index].name]!,
                                      playing: false,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
