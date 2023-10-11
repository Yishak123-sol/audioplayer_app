import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import '../controler/fetch_data_provider.dart';

class ArtWork extends StatefulWidget {
  const ArtWork({super.key});

  @override
  State<ArtWork> createState() => _ArtWorkState();
}

class _ArtWorkState extends State<ArtWork> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 250,
          width: 250,
          child: QueryArtworkWidget(
            controller: 
                Provider.of<FetchData>(context, listen: false).onAudioQuery,
            id: Provider.of<FetchData>(context, listen: false).songModel!.id,
            type: ArtworkType.AUDIO,
            nullArtworkWidget: ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Image.asset(
                'assets/music.png',
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
      ],
    );
  }
}
