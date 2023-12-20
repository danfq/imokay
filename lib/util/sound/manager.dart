import 'package:audioplayers/audioplayers.dart';

class AudioPlayerManager {
  ///Players
  static final Map<String, AudioPlayer> _players = {};

  ///Initialize Audio Service
  static void init() {
    //Set Global Context
    AudioPlayer.global.setAudioContext(
      const AudioContext(
        iOS: AudioContextIOS(
          category: AVAudioSessionCategory.playback,
          options: [
            AVAudioSessionOptions.allowBluetoothA2DP,
            AVAudioSessionOptions.allowBluetooth,
            AVAudioSessionOptions.mixWithOthers,
          ],
        ),
        android: AudioContextAndroid(audioFocus: AndroidAudioFocus.gain),
      ),
    );
  }

  ///Get Audio Player by `playerID`
  static AudioPlayer getPlayer(String playerID) {
    return _players.putIfAbsent(
      playerID,
      () => AudioPlayer(playerId: playerID),
    );
  }

  ///Set AudioPlayer Volume
  static Future<void> setPlayerVolume({
    required String playerID,
    required double volume,
  }) async {
    //Player
    final player = getPlayer(playerID);

    //Set Volume
    await player.setVolume(volume / 100);
  }

  ///Stop All AudioPlayers
  static void stopAllPlayers() async {
    for (final player in _players.values) {
      await player.stop();
    }
  }

  ///Update Loop Status by `playerID`
  static void updateLoopStatus(String playerID, bool loopStatus) {
    final player = _players[playerID];

    if (player != null) {
      player.setReleaseMode(loopStatus ? ReleaseMode.loop : ReleaseMode.stop);
    }
  }
}
