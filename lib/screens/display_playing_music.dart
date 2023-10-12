import 'dart:typed_data';
import 'package:audio/controler/database.dart';
import 'package:audio/controler/fetch_data_provider.dart';
import 'package:flutter/material.dart';
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
    FetchData fetchDataController =
        Provider.of<FetchData>(context, listen: false);
    Future<Uint8List?> albumArtwork =
        Provider.of<FetchData>(context, listen: false).fetchAlbumArtwork();
    @override
    insitstate() {
      albumArtwork;
      super.initState();
    }

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
            Provider.of<FetchData>(context, listen: false).image(),
            const DisplayPlayingMusic(),
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
                    dataBaseController.writeData(
                      fetchDataController.songModel!,
                    );
                  },
                  child: const Icon(
                    Icons.favorite,
                    size: 20,
                    color: Colors.red,
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
        const SizedBox(
          height: 30,
        ),
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
          height: 30,
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
                print('Songmodel${controllerFetchData.songModel}');
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

// class DisplayImage extends StatefulWidget {
//   const DisplayImage({super.key});

//   @override
//   State<DisplayImage> createState() => _DisplayImageState();
// }

// class _DisplayImageState extends State<DisplayImage> {
//   @override
//   Widget build(BuildContext context) {
//     Future<Uint8List?> albumArtwork =
//         Provider.of<FetchData>(context, listen: false).fetchAlbumArtwork();

//     @override
//     initState() {
//       albumArtwork;
//       super.initState();
//     }

//     return FutureBuilder<Uint8List?>(
//       future: albumArtwork,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const CircularProgressIndicator();
//         } else if (snapshot.hasError) {
//           return Text('Error: ${snapshot.error}');
//         } else if (!snapshot.hasData || snapshot.data == null) {
//           return const Text('No artwork available');
//         } else {
//           return Image.memory(
//             snapshot.data!,
//             width: 100,
//             height: 100,
//           );
//         }
//       },
//     );
//   }
// }
