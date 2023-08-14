import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:on_audio_query/on_audio_query.dart';

class StateManage extends ChangeNotifier {
  late bool isPlaying = false;
  late AudioPlayer player = AudioPlayer();
  Duration position = const Duration();
  Duration duration = const Duration();
  late DeviceFileSource path;
  late final SongModel songModel;

  void playPause(path) {
    if (isPlaying) {
      player.pause();
      isPlaying = false;
    } else {
      player.play(path);
      isPlaying = true;
    }
    notifyListeners();
  }

  Future initPlayer() async {
    // set a callback for changing duration

    player.onDurationChanged.listen((Duration d) {
      duration = d;
      notifyListeners();
    });

    // set a callback for position change
    player.onPositionChanged.listen((Duration p) {
      position = p;
      notifyListeners();
    });

    // set a callback for when audio ends
    player.onPlayerComplete.listen((_) {
      position = duration;
      notifyListeners();
    });
  }

  void cancel() {
    duration = Duration.zero;
    isPlaying = false;
    player.stop();
    position = duration;
    player.seek(duration);
    notifyListeners();
  }

  void songmodel({required songM}) {
    songModel = songM;
    notifyListeners();
  }
}
