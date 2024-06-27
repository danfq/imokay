import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:imokay/util/sound/all.dart';
import 'package:imokay/util/storage/local.dart';
import 'package:imokay/util/widgets/animations.dart';
import 'package:imokay/util/widgets/sound_item.dart';
import 'package:imokay/util/widgets/sounds.dart';

class Favorites extends StatefulWidget {
  const Favorites({super.key});

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  //Favorites
  late List? activeFavorites;
  final favorites = LocalStorage.boxData(box: "favorites");

  //Volume
  double volume =
      LocalStorage.boxData(box: "preferences")["def_volume"] ?? 80.0;

  //Current View
  String currentView = "list";

  @override
  void initState() {
    super.initState();

    //Set Active Favorites
    activeFavorites = favorites.entries.map((item) {
      if (item.value == true) {
        return item.key;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    //Grid or List
    Widget gridOrList() {
      if (currentView == "list") {
        //Grid Items
        List<Widget> gridItems = [];

        //Generate Grid Item
        for (final favorite in activeFavorites!) {
          final gridItem = SoundItem(
            playing: false,
            icon: soundIcons[favorite]!,
            data: SoundData(
              name: favorite,
            ),
            showFavorite: false,
            volume: volume,
          );

          //Add Favorites to List of Widgets
          gridItems.add(gridItem);
        }

        return GridView.count(
          crossAxisCount: 1,
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          childAspectRatio: 3,
          crossAxisSpacing: 0.5,
          mainAxisSpacing: 0.5,
          children: gridItems,
        );
      } else {
        //Grid Items
        List<Widget> gridItems = [];

        //Generate Grid Item
        for (final favorite in activeFavorites!) {
          final gridItem = SoundItem(
            playing: false,
            icon: soundIcons[favorite]!,
            data: SoundData(
              name: favorite,
            ),
            showFavorite: false,
            volume: volume,
          );

          //Add Favorites to List of Widgets
          gridItems.add(gridItem);
        }

        return GridView.count(
          crossAxisCount: 2,
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          childAspectRatio: 1,
          crossAxisSpacing: 0.5,
          mainAxisSpacing: 0.5,
          children: gridItems,
        );
      }
    }

    //Favorites List
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        title: Text(
          "Favorites",
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
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              onPressed: () {
                setState(() {
                  if (currentView == "grid") {
                    currentView = "list";
                  } else {
                    currentView = "grid";
                  }
                });
              },
              tooltip: "Change View",
              icon: Icon(
                color: Theme.of(context).iconTheme.color,
                (currentView == "grid")
                    ? Ionicons.ios_list
                    : Ionicons.ios_grid_outline,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: (activeFavorites!.isNotEmpty)
            ? gridOrList()
            : Center(
                child: AnimationsHandler.asset(
                  name: "empty",
                  repeat: true,
                ),
              ),
      ),
    );
  }
}
