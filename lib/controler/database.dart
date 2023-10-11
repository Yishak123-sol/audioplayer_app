import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Database extends ChangeNotifier {
  final _myBox = Hive.box('favoriteSongs');

  writeData(SongModel songModel) {
    _myBox.add(({
      songModel: songModel,
    }));
    notifyListeners();
  }

  readData() {
    return _myBox.values;
  }

  deletData(int index) {
    return _myBox.deleteAt(index);
  }

  Future<void> deleteHiveBox() async {
    await Hive.deleteBoxFromDisk('favoriteSongs');
  }
}
