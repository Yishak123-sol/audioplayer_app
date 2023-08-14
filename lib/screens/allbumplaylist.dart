import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

import 'displayplayingmusic.dart';

class AlbumSongsScreen extends StatelessWidget {
  final AlbumModel album;

  const AlbumSongsScreen({Key? key, required this.album}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final audioQuery = OnAudioQuery();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black12,
        title: Text(album.album.toString()),
      ),
      body: FutureBuilder<List<SongModel>>(
        future: audioQuery.querySongs(),
        builder: (context, item) {
          if (item.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (item.hasError) {
            return Center(
              child: Text('Error: ${item.error}'),
            );
          } else if (item.data == null) {
            return const Text('No songs found');
          } else {
            final songs =
                item.data!.where((song) => song.albumId == album.id).toList();

            return ListView.builder(
              itemCount: songs.length,
              itemBuilder: (context, index) {
                final song = songs[index];

                return Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: ListTile(
                    leading: QueryArtworkWidget(
                      id: song.id,
                      type: ArtworkType.AUDIO,
                      nullArtworkWidget: const Icon(
                        Icons.music_note,
                        size: 30,
                      ),
                    ),
                    title: Text(song.artist.toString()),
                    subtitle: Text(song.title),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DisplayPlayingSongs(
                            songModel1: song,
                          ),
                        ),
                      ); // Navigator
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
