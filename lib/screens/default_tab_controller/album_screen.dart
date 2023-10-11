import 'package:audio/controler/fetch_data_provider.dart';
import 'package:audio/screens/allbum_songs_screen.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class AlbumScreen extends StatefulWidget {
  const AlbumScreen({super.key});

  @override
  State<AlbumScreen> createState() => _AlbumScreenState();
}

class _AlbumScreenState extends State<AlbumScreen> {
  @override
  Widget build(BuildContext context) {
    Future<List<AlbumModel>> fetchdata =
        Provider.of<FetchData>(context, listen: false).fetchAlbum();
    return FutureBuilder<List<AlbumModel>>(
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
              return Container();
            }
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: GestureDetector(
                onTap: () {
                  Provider.of<FetchData>(context, listen: false)
                      .albumId(item.data![index].id);
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return const AlbumSongsScreen();
                  }));
                },
                child: ListTile(
                  leading: QueryArtworkWidget(
                    artworkHeight: 40,
                    artworkWidth: 40,
                    artworkBorder: const BorderRadius.all(Radius.circular(8)),
                    id: item.data![index].id,
                    type: ArtworkType.ALBUM,
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
                        artist.album.toString(),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text('${artist.numOfSongs.toString()} Songs',
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
