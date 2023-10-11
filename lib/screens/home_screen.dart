import 'package:audio/screens/default_tab_controller/all_songs_screen.dart';
import 'package:audio/screens/search.dart';
import 'package:audio/widgets/favorite.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../controler/fetch_data_provider.dart';
import 'default_tab_controller/album_screen.dart';
import 'default_tab_controller/artist_screen.dart';
import 'display_playing_music.dart';

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
    final fetchDataController = Provider.of<FetchData>(context);
    return DefaultTabController(
      length: tabs.length,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            actions: [
              GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) {
                          return const Search();
                        },
                      ),
                    );
                  },
                  child: const Icon(Icons.search)),
              const SizedBox(
                width: 10,
              ),
              const Icon(Icons.more_vert),
              const SizedBox(
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
                    AllSongsScreen(),
                    AlbumScreen(),
                    Favorite(),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: !fetchDataController.bottomDisplayFunc()
              ? null
              : GestureDetector(
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                    return const DisplayPlayingSongs();
                  })),
                  child: Container(
                    color: const Color.fromARGB(221, 34, 34, 34),
                    height: 70,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  fetchDataController
                                      .listOfSongMOdel![
                                          fetchDataController.index!]
                                      .artist
                                      .toString(),
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  fetchDataController
                                      .listOfSongMOdel![
                                          fetchDataController.index!]
                                      .title
                                      .toString(),
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(color: Colors.grey),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 25),
                            child: InkWell(
                              onTap: () {
                                fetchDataController.playPause();
                              },
                              child: fetchDataController.isPlaying
                                  ? const Icon(
                                      Icons.pause_circle,
                                      size: 35,
                                    )
                                  : const Icon(
                                      Icons.play_circle,
                                      size: 35,
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
