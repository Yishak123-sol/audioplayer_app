import 'package:audio/widgets/songs_screen.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

import '../../controler/fetch_data_provider.dart';

class AllSongsScreen extends StatefulWidget {
  const AllSongsScreen({super.key});

  @override
  State<AllSongsScreen> createState() => _AllSongsScreenState();
}

class _AllSongsScreenState extends State<AllSongsScreen> {
  @override
  Widget build(BuildContext context) {
    Future<List<SongModel>> fetchdata =
        Provider.of<FetchData>(context, listen: false).fetchSongs();
    return Scaffold(
      body: SongsScreen(fetchdata: fetchdata),
    );
  }
}
