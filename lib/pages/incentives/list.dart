import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:imokay/util/notifications/incentives.dart';
import 'package:imokay/util/notifications/local.dart';
import 'package:imokay/util/storage/local.dart';

class IncentivesList extends StatefulWidget {
  const IncentivesList({super.key});

  @override
  State<IncentivesList> createState() => _IncentivesListState();
}

class _IncentivesListState extends State<IncentivesList> {
  //List Scroll Controller
  final ScrollController listController = ScrollController(
    initialScrollOffset: 0.0,
  );

  //New Incentive Controller
  final TextEditingController newIncentiveController = TextEditingController();

  //Incentives
  List<String> incentives = IncentiveNotifications.incentives;

  // AnimatedList Key
  final GlobalKey<AnimatedListState> _animatedListKey =
      GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Incentives",
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
        actions: [
          IconButton(
            onPressed: () async {
              //Show New Incentive Sheet
              await showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(14.0),
                    topRight: Radius.circular(14.0),
                  ),
                ),
                builder: (context) {
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Text(
                              "New Incentive",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: TextField(
                              controller: newIncentiveController,
                              decoration: const InputDecoration(
                                hintText: "Write Your Incentive Here",
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(40.0),
                            child: ElevatedButton(
                              onPressed: () async {
                                //Check Incentive Content
                                if (newIncentiveController.text
                                    .trim()
                                    .isEmpty) {
                                  LocalNotifications.toast(
                                    message:
                                        "Your New Incentive Can't Be Empty",
                                  );
                                } else {
                                  //Add New Incentive
                                  setState(() {
                                    incentives.insert(
                                      0,
                                      newIncentiveController.text.trim(),
                                    );
                                    _animatedListKey.currentState
                                        ?.insertItem(0);
                                  });

                                  await LocalStorage.setData(
                                    box: "incentives",
                                    data: {
                                      "list": incentives,
                                    },
                                  );

                                  //Notify User
                                  LocalNotifications.toast(
                                    message: "Added New Incentive",
                                  );

                                  //Close Sheet
                                  if (mounted) {
                                    Navigator.pop(context);
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).cardColor,
                              ),
                              child: const Text("Add Incentive"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            tooltip: "Add Incentive",
            icon: const Icon(
              Ionicons.add_circle_outline,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: AnimatedList(
          key: _animatedListKey,
          controller: listController,
          physics: const BouncingScrollPhysics(),
          reverse: false,
          initialItemCount: incentives.length,
          itemBuilder: (context, index, animation) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              child: SizeTransition(
                sizeFactor: animation,
                child: SizedBox(
                  width: double.infinity,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14.0),
                    onLongPress: () async {
                      //Remove Incentive Confirmation Dialog
                      final confirmationDialog = await confirm(
                        context,
                        title: const Text("Remove Incentive"),
                        content: const Text(
                          "Would you like to remove this Incentive?",
                        ),
                        textOK: const Text("Remove"),
                        textCancel: const Text("Cancel"),
                      );

                      //Ask if User Wants to Remove Incentive
                      if (confirmationDialog) {
                        //Remove Incentive
                        incentives.removeAt(index);

                        _animatedListKey.currentState?.removeItem(
                          index,
                          (context, animation) => Container(),
                        );

                        await LocalStorage.setData(
                          box: "incentives",
                          data: {
                            "list": incentives,
                          },
                        );

                        //Notify User
                        LocalNotifications.toast(message: "Incentive Removed");
                      }
                    },
                    child: Card(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(14.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          incentives[index],
                        ),
                      ),
                    ),
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
