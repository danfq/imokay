import 'package:flutter_riverpod/flutter_riverpod.dart';

final activePlayersProvider =
    StateNotifierProvider<ActivePlayersNotifier, List<String>>((ref) {
  return ActivePlayersNotifier();
});

class ActivePlayersNotifier extends StateNotifier<List<String>> {
  ActivePlayersNotifier() : super([]);

  void startPlayer(String playerID) {
    state = [...state, playerID];
  }

  void stopPlayer(String playerID) {
    state = state.where((id) => id != playerID).toList();
  }
}
