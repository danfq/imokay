import 'package:just_audio/just_audio.dart';

/// Audio Player Manager
class AudioPlayerManager {
  /// Players
  static final Map<String, AudioPlayer> _players = {};

  /// Get Audio Player by `playerID`
  static AudioPlayer getPlayer(String playerID) {
    return _players.putIfAbsent(
      playerID,
      () => AudioPlayer(),
    );
  }

  /// Set Focus Mode
  ///
  /// If enabling, set all Sounds as Looping, else set them to Finish
  static Future<void> setFocusMode({required bool mode}) async {
    for (final player in _players.values) {
      await player.setLoopMode(mode ? LoopMode.one : LoopMode.off);
    }
  }

  /// Set AudioPlayer Volume
  static Future<void> setPlayerVolume({
    required String playerID,
    required double volume,
  }) async {
    // Player
    final player = getPlayer(playerID);

    // Set Volume
    await player.setVolume(volume / 100);
  }

  /// Set Volume for All Players
  static Future<void> setVolume({required double volume}) async {
    // Set Volume for All Players
    for (final player in _players.values) {
      await player.setVolume(volume / 100);
    }
  }

  /// Stop All AudioPlayers
  static Future<void> stopAllPlayers() async {
    for (final player in _players.values) {
      await player.stop();
    }
  }

  /// Update Loop Status by `playerID`
  static Future<void> updateLoopStatus(String playerID, bool loopStatus) async {
    final player = _players[playerID];

    if (player != null) {
      await player.setLoopMode(loopStatus ? LoopMode.one : LoopMode.off);
    }
  }
}
