import 'package:audio/screens/artist_screen.dart';
import 'package:audio/screens/songs_screen.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'albums_screen.dart';
import 'music_palying.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    permissionrequest();
    super.initState();
  }

  void permissionrequest() {
    Permission.storage.request();
  }

  final List<Widget> tabs = const [
    Column(
      children: [
        Icon(
          Icons.person,
          size: 30.0,
          color: Colors.white,
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          'ARTISTS',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
        )
      ],
    ),
    Column(
      children: [
        Icon(
          Icons.music_note,
          size: 30.0,
          color: Colors.white,
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          'SONGS',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
        )
      ],
    ),
    Column(
      children: [
        Icon(
          Icons.album,
          size: 30.0,
          color: Colors.white,
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          'ALBUMS',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        )
      ],
    ),
    Column(
      children: [
        Icon(
          Icons.queue_music,
          size: 30.0,
          color: Colors.white,
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          'PLAYLIST',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
        )
      ],
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            actions: const [
              Icon(Icons.search),
              SizedBox(
                width: 10,
              ),
              Icon(Icons.more_vert),
              SizedBox(
                width: 20,
              ),
            ],
          ),
          body: Column(
            children: [
              TabBar(tabs: tabs),
              const Expanded(
                child: TabBarView(
                  children: [
                    ArtistScreen(),
                    SongsScreen(),
                    AlbumScreen(),
                    Center(child: Text('per')),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: const MusicisPlaying(),
        ),
      ),
    );
  }
}
