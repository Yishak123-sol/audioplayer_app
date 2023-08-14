import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AlbumScreen extends StatefulWidget {
  const AlbumScreen({super.key});

  @override
  State<AlbumScreen> createState() => _AlbumScreenState();
}

class _AlbumScreenState extends State<AlbumScreen> {
  final audioQuery = OnAudioQuery();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<AlbumModel>>(
      future: audioQuery.queryAlbums(
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
            return Text(artist.artist.toString());
          },
        );
      },
    );
  }
}


