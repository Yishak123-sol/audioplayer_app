import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class FetchData extends ChangeNotifier {
  final OnAudioQuery onAudioQuery = OnAudioQuery();

  // Fetch Songs

  Future<List<AlbumModel>> fetchAlbum() async {
    final List<AlbumModel> fetchedAlbumSongs = await onAudioQuery.queryAlbums(
      sortType: null,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );
    return fetchedAlbumSongs;
  }

  Future<List<ArtistModel>> fetchArtist() async {
    final List<ArtistModel> fetchedArtistSongs =
        await onAudioQuery.queryArtists(
      sortType: null,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );
    return fetchedArtistSongs;
  }

  List<SongModel> searchSongs = [];

  Future<List<SongModel>> fetchSongs() async {
    final List<SongModel> fetchedSongs = await onAudioQuery.querySongs(
      sortType: null,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );
    searchSongs = fetchedSongs;
    return fetchedSongs;
  }

  Future<List<SongModel>> fetchSongsByArtistName() async {
    final List<SongModel> fetchedArtistSongs = await fetchSongs();
    final List<SongModel> songsByArtist =
        fetchedArtistSongs.where((song) => song.artistId! == artistid).toList();
    return songsByArtist;
  }

  Future<List<SongModel>> fetchSongsByAlbumName() async {
    final List<SongModel> fetchedAlbumSongs = await fetchSongs();
    final List<SongModel> songsByAlbum =
        fetchedAlbumSongs.where((song) => song.albumId! == albumid).toList();

    return songsByAlbum;
  }

  //Playing music

  late bool isPlaying = false;
  late bool bottomDisplay = false;
  late bool isPaused = false;
  late AudioPlayer player = AudioPlayer();
  Duration position = const Duration();
  Duration duration = const Duration();
  late DeviceFileSource path;
  late SongModel providersongModel;

  Future initPlayer() async {
    player.onDurationChanged.listen((Duration d) {
      duration = d;
      notifyListeners();
    });

    // set a callback for position change
    player.onPositionChanged.listen(
      (Duration p) {
        position = p;
        notifyListeners();
      },
    );

    // set a callback for when audio ends
    player.onPlayerComplete.listen(
      (_) {
        position = duration;
        incrementIndex();
        notifyListeners();
      },
    );
  }

  AsyncSnapshot<List<SongModel>>? item;
  int? index;
  int? allSongsInde;
  List<SongModel>? listOfSongMOdel;
  SongModel? songModel;
  int? length;
  int? id;

  List<SongModel> provideListOfSongModel(listOfItems) {
    item = listOfItems;
    listOfSongMOdel = item!.data;
    length = listOfSongMOdel!.length;
    notifyListeners();
    return listOfSongMOdel!;
  }

  getIndex(int currentIndex) {
    index = currentIndex;
    id = listOfSongMOdel![index!].id;
    notifyListeners();
    return index;
  }

  // get albuma and artist id
  int? albumid;
  int? artistid;

  int albumId(int id) {
    albumid = id;
    notifyListeners();
    return albumid!;
  }

  int artistId(int id) {
    artistid = id;
    notifyListeners();
    return artistid!;
  }

  void incrementIndex() async {
    if ((length! - 1) > index!) {
      index = index! + 1;
      songModel = listOfSongMOdel![index!];
      artist = listOfSongMOdel![index!].artist;
      title = listOfSongMOdel![index!].title;
      id = listOfSongMOdel![index!].id;
      notifyListeners();
      await cancel();
    } else {
      index = 0;
      songModel = listOfSongMOdel![index!];
      artist = listOfSongMOdel![index!].artist;
      title = listOfSongMOdel![index!].title;
      id = listOfSongMOdel![index!].id;
      notifyListeners();
      await cancel();
    }
  }

  void decrementIndex() async {
    if (index! > 0) {
      index = index! - 1;
      artist = listOfSongMOdel![index!].artist;
      title = listOfSongMOdel![index!].title;
      id = listOfSongMOdel![index!].id;
      notifyListeners();
      await cancel();
    } else {
      index = length! - 1;
      artist = listOfSongMOdel![index!].artist;
      title = listOfSongMOdel![index!].title;
      id = listOfSongMOdel![index!].id;
      notifyListeners();
      await cancel();
    }
  }

  String? artist;
  String? title;

  void playPause() async {
    if (isPlaying) {
      await player.pause();
      isPlaying = false;
    } else {
      songModel = listOfSongMOdel![index!];
      path = DeviceFileSource(songModel!.data);
      await player.play(path);
      isPlaying = true;
      isPaused = true;
    }
    notifyListeners();
  }

  cancel() async {
    await player.stop();
    position = const Duration();
    isPlaying = false;
    playPause();
    notifyListeners();
  }

  // bottomDisplay function
  bool bottomDisplayFunc() {
    if (!isPaused && !isPlaying) {
      bottomDisplay = false;
    } else {
      bottomDisplay = true;
    }
    return bottomDisplay;
  }

  Future<Uint8List?> fetchAlbumArtwork() async {
    // Fetch album artwork data for the given URI
    Uint8List? albumArtwork = await onAudioQuery.queryArtwork(
      songModel!.id,
      ArtworkType.AUDIO,
    );

    return albumArtwork;
  }

  Widget image() {
    return FutureBuilder<Uint8List?>(
      future: fetchAlbumArtwork(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const Text('No artwork available');
        } else {
          return Image.memory(
            snapshot.data!,
            width: 300,
            height: 300, 
          );
        }
      },
    );
  }
}
