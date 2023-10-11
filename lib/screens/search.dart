import 'package:audio/controler/fetch_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();
    Future<List<SongModel>> fetchdata =
        Provider.of<FetchData>(context, listen: false).fetchSongs();

    @override
    void initstate() {
      fetchdata = Provider.of<FetchData>(context, listen: false).fetchSongs();
      super.initState();
    }

    return SafeArea(
        child: Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back)),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                    child: TextField(
                  controller: searchController,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    fillColor: Colors.grey,
                    filled: true,
                    hintText: 'Search',
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                  ),
                )),
                const SizedBox(
                  width: 10,
                ),
                const Icon(
                  Icons.search,
                  size: 30,
                )
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            Column(
              children: [
                FutureBuilder<List<SongModel>>(
                  future: fetchdata,
                  builder: (BuildContext context, item) {
                    final filteredList = item.data
                        ?.where((song) => song.title
                            .toLowerCase()
                            .contains(searchController.text.toLowerCase()))
                        .toList();

                    if (filteredList == null) {
                      return Container(
                        color: Colors.black,
                      );
                    }
                    if (filteredList.isEmpty) {
                      return const Center(
                        child: Text('No matching songs found.'),
                      );
                    }
                    return ListView.builder(
                      itemCount: filteredList.length,
                      itemBuilder: (BuildContext context, index) {
                        final artist = filteredList[index];
                        return ListTile(
                          title: Text(artist.toString()),
                        );
                      },
                    );
                  },
                )
              ],
            )
          ],
        ),
      ),
    ));
  }
}
