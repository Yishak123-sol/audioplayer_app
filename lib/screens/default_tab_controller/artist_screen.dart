import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

import '../../controler/fetch_data_provider.dart';
import '../artist_songs_screen.dart';

class ArtistScreen extends StatefulWidget {
  const ArtistScreen({super.key});

  @override
  State<ArtistScreen> createState() => _ArtistScreenState();
}

class _ArtistScreenState extends State<ArtistScreen> {
  @override
  Widget build(BuildContext context) {
    Future<List<ArtistModel>> fetchdata =
        Provider.of<FetchData>(context, listen: false).fetchArtist();
    return FutureBuilder<List<ArtistModel>>(
      future: fetchdata,
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
                  Provider.of<FetchData>(context, listen: false).artistId(item.data![index].id);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) {
                        return const ArtistSongsScreen();
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
                    type: ArtworkType.ARTIST,
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
                      Text('${artist.numberOfTracks.toString()} Songs',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.grey)),
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
