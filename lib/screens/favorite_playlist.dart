import 'package:audio/controler/database.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class FavortiePlayList extends StatelessWidget {
  const FavortiePlayList({super.key});

  @override
  Widget build(BuildContext context) {
    Database dataBaseController = Provider.of<Database>(context, listen: false);

    List<Widget> favoriteList() {
      List<Widget> favorite = [];

      final favoriteList = dataBaseController.readData();

      Map favoriteSong;
      for (favoriteSong in favoriteList) {
        final listTile = GestureDetector(
          onTap: () => {},
          child: ListTile(
            leading: QueryArtworkWidget(
              artworkHeight: 40,
              artworkWidth: 40,
              artworkBorder: const BorderRadius.all(Radius.circular(8)),
              id: favoriteSong['id'],
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
                  favoriteSong['artist'].toString(),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(favoriteSong['titel'].toString(),
                    style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        );
        favorite.add(listTile);
      }
      return favorite;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back,
            color: Colors.greenAccent,
          ),
        ),
      ),
      body: ListView(
        children: favoriteList(),
      ),
    );
  }
}
