import 'package:audio/controler/database.dart';
import 'package:audio/controler/fetch_data_provider.dart';
import 'package:audio/screens/default_tab_controller/all_songs_screen.dart';
import 'package:audio/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('favoriteSongs');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<FetchData>(create: (context) => FetchData()),
        ChangeNotifierProvider<Database>(create: (context) => Database()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Colors.black, brightness: Brightness.light),
      home: const HomeScreen(),
    );
  }
}
