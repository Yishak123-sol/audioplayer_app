import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../screens/allbumplaylist.dart';

class HorizontalListBuilder extends StatelessWidget {
  const HorizontalListBuilder({
    super.key,
    required this.audioQuery,
  });

  final OnAudioQuery audioQuery;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<AlbumModel>>(
      future: audioQuery.queryAlbums(
        sortType: null,
        ignoreCase: true,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
      ),
      builder: (context, item) {
        if (item.data == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (item.data!.isEmpty) {
          return const Text('Songs not found');
        }
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: item.data!.length,
          itemBuilder: (context, index) => Padding(
            padding:
                const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AlbumSongsScreen(album: item.data![index]),
                  ),
                );
              },
              child: Column(
                children: [
                  SizedBox(
                    height: 130,
                    width: 130,
                    child: QueryArtworkWidget(
                      id: item.data![index].id,
                      type: ArtworkType.ALBUM,
                      nullArtworkWidget: ClipRRect(
                        borderRadius: BorderRadius.circular(43),
                        child: Image.asset(
                          'assets/sa.jpg',
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    item.data![index].album.toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(item.data![index].artist.toString(),
                      style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
