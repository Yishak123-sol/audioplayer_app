import 'package:audio/controler/fetch_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'display_playing_music.dart';

class AlbumSongsScreen extends StatefulWidget {
  const AlbumSongsScreen({Key? key}) : super(key: key);

  @override
  State<AlbumSongsScreen> createState() => _AlbumSongsScreenState();
}

class _AlbumSongsScreenState extends State<AlbumSongsScreen> {
  @override
  Widget build(BuildContext context) {
    final controllerFetchData = Provider.of<FetchData>(context, listen: false);

    final Future<List<SongModel>> fetchdata =
        controllerFetchData.fetchSongsByAlbumName();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black12,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.greenAccent,
            size: 30,
          ),
        ),
      ),
      body: FutureBuilder<List<SongModel>>(
        future: fetchdata,
        builder: (context, item) {
          if (item.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.grey,
              ),
            );
          } else if (item.hasError) {
            return Center(
              child: Text('Error: ${item.error}'),
            );
          } else if (item.data == null) {
            return const Text('No songs found');
          } else {
            final songs = item.data!;

            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: songs.length,
              itemBuilder: (context, index) {
                final song = songs[index];

                return Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: GestureDetector(
                    onTap: () {
                      controllerFetchData.provideListOfSongModel(item);
                      controllerFetchData.getIndex(index);
                      controllerFetchData.length;
                      if (controllerFetchData.isPlaying) {
                        controllerFetchData.cancel();
                      } else {
                        controllerFetchData.playPause();
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) {
                            return const DisplayPlayingSongs();
                          },
                        ),
                      );
                    },
                    child: ListTile(
                      leading: QueryArtworkWidget(
                        artworkHeight: 40,
                        artworkWidth: 40,
                        artworkBorder:
                            const BorderRadius.all(Radius.circular(8)),
                        id: song.id,
                        type: ArtworkType.AUDIO,
                        nullArtworkWidget: const Image(
                          height: 40,
                          width: 40,
                          fit: BoxFit.cover,
                          image: AssetImage('assets/music.png'),
                        ),
                      ),
                      title: Text(
                        song.artist.toString(),
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        song.title,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
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
