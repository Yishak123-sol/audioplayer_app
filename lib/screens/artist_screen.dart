import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ArtistScreen extends StatefulWidget {
  const ArtistScreen({super.key});

  @override
  State<ArtistScreen> createState() => _ArtistScreenState();
}

class _ArtistScreenState extends State<ArtistScreen> {
  final audioQuery = OnAudioQuery();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ArtistModel>>(
      future: audioQuery.queryArtists(
        sortType: null,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
        ignoreCase: true,
      ),
      builder: (BuildContext context, item) {
        if (item.data == null) {
          return const Center(child: CircularProgressIndicator());
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
              child: ListTile(
                leading: QueryArtworkWidget(
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
                    Text(
                      artist.artist.toString(),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      artist.numberOfTracks.toString(),
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.grey)
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
