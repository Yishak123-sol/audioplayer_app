import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import '../controler/provider.dart';

class DisplayPlayingSongs extends StatelessWidget {
  const DisplayPlayingSongs({super.key, required this.songModel1});

  final SongModel songModel1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black12,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            return Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            ArtWork(
              songModel: songModel1,
            ),
            const SizedBox(height: 30,),
            DisplayPlayingMusic(
              songModel: songModel1,
            ),
          ],
        ),
      ),
    );
  }
}

class DisplayPlayingMusic extends StatefulWidget {
  const DisplayPlayingMusic({Key? key, required this.songModel})
      : super(key: key);
  final SongModel songModel;

  @override
  State<DisplayPlayingMusic> createState() => _DisplayPlayingMusicState();
}

class _DisplayPlayingMusicState extends State<DisplayPlayingMusic> {
  late final DeviceFileSource path;
  late final s = null;

  bool isPlaying = false;

  Duration duration = const Duration();
  Duration position = const Duration();

  @override
  void initState() {
    Provider.of<StateManage>(context, listen: false).initPlayer();
    path = DeviceFileSource(widget.songModel.data);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<StateManage>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          children: [
            // slider
            Slider(
              value: controller.position.inSeconds.toDouble(),
              onChanged: (value) {
                controller.player.seek(Duration(seconds: value.toInt()));
              },
              min: 0,
              max: controller.duration.inSeconds.toDouble(),
              activeColor: Colors.white,
              inactiveColor: Colors.grey,
              thumbColor: Colors.white,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(controller.position.toString().substring(2, 7)),
                Text(controller.duration.toString().substring(2, 7)),
              ],
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
            const Icon(
              Icons.skip_previous,
              size: 45,
            ),
            const SizedBox(
              width: 35.0,
            ),
            // play btn
            InkWell(
              onTap: () {
                controller.playPause(path);
              },
              child: controller.isPlaying
                  ? const Icon(
                      Icons.pause_circle,
                      size: 60,
                    )
                  : const Icon(
                      Icons.play_circle,
                      size: 60,
                    ),
            ),
            // next btn
            const SizedBox(
              width: 35.0,
            ),
            const Icon(
              Icons.skip_next,
              size: 45,
            ),
          ],
        ),
      ],
    );
  }
}

class ArtWork extends StatelessWidget {
  const ArtWork({super.key, required this.songModel});

  final SongModel songModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 250,
          width: 250,
          child: QueryArtworkWidget(
            id: songModel.id,
            type: ArtworkType.AUDIO,
            nullArtworkWidget: ClipRRect(
              borderRadius: BorderRadius.circular(40),
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
          height: 20,
        ),
        Text(songModel.artist.toString(),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            )),
        Text(songModel.title.toString()),
      ],
    );
  }
}
