import 'package:audio/screens/display_playing_music.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

import '../controler/fetch_data_provider.dart';

// ignore: must_be_immutable
class SongsScreen extends StatefulWidget {
SongsScreen({super.key, required this.fetchdata});
  Future<List<SongModel>> fetchdata;

  @override
  State<SongsScreen> createState() => _SongsScreenState();
}

class _SongsScreenState extends State<SongsScreen> {
  @override
  Widget build(BuildContext context) {
    final controllerFetchData = Provider.of<FetchData>(context, listen: false);

    return FutureBuilder<List<SongModel>>(
      future: widget.fetchdata,
      builder: (BuildContext context, item) {
        if (item.data == null) {
          return Container(
            color: Colors.black,
          );
        }
        if (item.data!.isEmpty) {
          return const Center(
            child: Text('you have no songs'),
          );
        }
        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: item.data!.length,
          itemBuilder: (BuildContext context, index) {
            final artist = item.data![index];
            if (artist.id == 0) {
              return const SizedBox();
            }
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: GestureDetector(
                onTap: () {
                  controllerFetchData.provideListOfSongModel(item);
                  controllerFetchData.getIndex(index);
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
                    artworkBorder: const BorderRadius.all(Radius.circular(8)),
                    id: item.data![index].id,
                    type: ArtworkType.AUDIO,
                    artworkFit: BoxFit.cover,
                    nullArtworkWidget: const Image(
                      height: 40,
                      width: 40,
                      image: AssetImage('assets/music.png'),
                    ),
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(artist.artist.toString(),
                          overflow: TextOverflow.ellipsis),
                      Text(
                        artist.title.toString(),
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
