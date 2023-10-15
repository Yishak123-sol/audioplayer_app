import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Database extends ChangeNotifier {
  final _myBox = Hive.box('favoriteSongs');

  writeData(SongModel? songModel) {
    if (!isInFavoriteList(songModel!.title)) {
      _myBox.add(({
        "data": songModel.data,
        "id": songModel.id,
        "titel": songModel.title,
        "artist": songModel.artist,
        "album": songModel.album
      }));
    } else {
      List<dynamic> favoriteList = readData();
      int index = 0;

      for (dynamic favorite in favoriteList) {
        if (favorite['titel'] == songModel.title) {
          deletData(index);
        }
        index = index + 1;
      }
    }
    notifyListeners();
  }

  readData() {
    return _myBox.values.toList();
  }

  deletData(int index) {
    return _myBox.deleteAt(index);
  }

  Future<void> deleteHiveBox() async {
    await Hive.deleteBoxFromDisk('favoriteSongs');
  }

  bool isInfavorite = false;
  isInFavoriteList(String titel) {
    List<dynamic> favoriteList = readData();
    dynamic favorite;

    for (favorite in favoriteList) {
      if (favorite['titel'] == titel) {
        return true;
      }
    }
    return false;
  }
}
