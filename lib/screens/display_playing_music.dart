import 'package:audio/controler/database.dart';
import 'package:audio/controler/fetch_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class DisplayPlayingSongs extends StatefulWidget {
  const DisplayPlayingSongs({super.key});

  @override
  State<DisplayPlayingSongs> createState() => _DisplayPlayingSongsState();
}

class _DisplayPlayingSongsState extends State<DisplayPlayingSongs> {
  @override
  void initState() {
    Provider.of<FetchData>(context, listen: false).initPlayer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Database dataBaseController = Provider.of<Database>(context, listen: false);
    FetchData fetchDataController = Provider.of<FetchData>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0.0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(
            Icons.arrow_back,
            size: 30,
            color: Colors.greenAccent,
          ),
        ),
        title: const Text('Nowplaying'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const Image(
                  height: 300,
                  width: 300,
                  fit: BoxFit.cover,
                  image: AssetImage('assets/music.png'),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(fetchDataController.songModel!.artist.toString()),
                Text(
                  fetchDataController.songModel!.title.toString(),
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(
                  height: 20,
                ),
                const DisplayPlayingMusic(),
              ],
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(
                      Icons.menu,
                      size: 20,
                      color: Color.fromRGBO(255, 255, 255, 1),
                    ),
                    GestureDetector(
                      onTap: () {
                        SongModel? songModel = fetchDataController.songModel;
                        dataBaseController.writeData(songModel);
                      },
                      child: Icon(
                        Icons.favorite,
                        size: 20,
                        color: Provider.of<Database>(context).isInFavoriteList(
                                fetchDataController.songModel!.title)
                            ? Colors.red
                            : Colors.white,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        print(dataBaseController.readData());
                      },
                      child: const Icon(
                        Icons.shuffle,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                    const Icon(
                      Icons.more_horiz,
                      size: 20,
                      color: Colors.white,
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class DisplayPlayingMusic extends StatefulWidget {
  const DisplayPlayingMusic({Key? key}) : super(key: key);

  @override
  State<DisplayPlayingMusic> createState() => _DisplayPlayingMusicState();
}

class _DisplayPlayingMusicState extends State<DisplayPlayingMusic> {
  bool isPlaying = false;
  Duration duration = const Duration();
  Duration position = const Duration();

  @override
  Widget build(BuildContext context) {
    final controllerFetchData = Provider.of<FetchData>(context);

// Fetch the album artwork

    return Column(
      children: [
        Slider(
          value: controllerFetchData.position.inSeconds.toDouble(),
          onChanged: (value) {
            controllerFetchData.player.seek(Duration(seconds: value.toInt()));
          },
          min: 0.0,
          max: controllerFetchData.duration.inSeconds.toDouble(),
          activeColor: Colors.white,
          inactiveColor: Colors.grey,
          thumbColor: Colors.white,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              controllerFetchData.position.toString().substring(2, 7),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              controllerFetchData.duration.toString().substring(2, 7),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // previous btn
            GestureDetector(
              onTap: () => {
                controllerFetchData.decrementIndex(),
              },
              child: const Icon(
                Icons.skip_previous,
                size: 30,
              ),
            ),
            const SizedBox(
              width: 35.0,
            ),
            // play btn
            InkWell(
              onTap: () {
                controllerFetchData.playPause();
              },
              child: controllerFetchData.isPlaying
                  ? const Icon(
                      Icons.pause_circle,
                      size: 50,
                    )
                  : const Icon(
                      Icons.play_circle,
                      size: 50,
                    ),
            ),
            // next btn
            const SizedBox(
              width: 35.0,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  Provider.of<FetchData>(context, listen: false)
                      .incrementIndex();
                  Provider.of<FetchData>(context).image();
                });
              },
              child: const Icon(
                Icons.skip_next,
                size: 30,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
