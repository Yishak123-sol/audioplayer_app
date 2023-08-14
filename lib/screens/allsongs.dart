import 'package:audio/controler/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../reusablewidgets/horizontallistbuilder.dart';
import 'displayplayingmusic.dart';

class AllSongs extends StatelessWidget {
  AllSongs({super.key});

  final OnAudioQuery audioQuery = OnAudioQuery();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.black12,
          leading: const Icon(
            Icons.menu,
            size: 30,
          ),
          title: const Text(
            'Music Player',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              )),
          actions: const [Icon(Icons.search)],
        ),
        body: FutureBuilder<PermissionStatus>(
            future: Permission.storage.request(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.data == PermissionStatus.granted) {
                return SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 10.0, bottom: 15.0),
                          child: Text(
                            'Folders',
                            style: TextStyle(
                                fontSize: 23, fontWeight: FontWeight.bold),
                          ),
                        ),
                        // horizontal list building
                        SizedBox(
                          height: 200,
                          child: HorizontalListBuilder(audioQuery: audioQuery),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 8, bottom: 8),
                          child: Text(
                            'All Songs',
                            style: TextStyle(fontSize: 23),
                          ),
                        ),
                        SizedBox(
                          height: 900,
                          child: FutureBuilder<List<SongModel>>(
                            future: audioQuery.querySongs(
                              uriType: UriType.EXTERNAL,
                              ignoreCase: true,
                              sortType: null,
                              orderType: OrderType.ASC_OR_SMALLER,
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
                              //vertical list builder
                              return ListView.builder(
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      Provider.of<StateManage>(context,
                                              listen: false)
                                          .playPause(DeviceFileSource(
                                              item.data![index].data));
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) {
                                          return DisplayPlayingSongs(
                                            songModel1: item.data![index],
                                          );
                                        }),
                                      );
                                    },
                                    child: ListTile(
                                      leading: QueryArtworkWidget(
                                        id: item.data![index].id,
                                        type: ArtworkType.AUDIO,
                                        nullArtworkWidget: const Icon(
                                          Icons.music_note,
                                          size: 30,
                                        ),
                                      ),
                                      title: Text(item.data![index].artist.toString()),
                                      subtitle: Text(item.data![index].title.toString()),
                                    ),
                                  );
                                },
                                itemCount: item.data!.length,
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }
              return const Center(
                child: Text('permission not granted'),
              );
            }),
      ),
    );
  }
}
