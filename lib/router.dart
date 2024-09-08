import 'package:flutter/material.dart';

import 'package:songbookapp/Screens/DownloadScreen.dart';
import 'package:songbookapp/Screens/HomePage.dart';
import 'package:songbookapp/Screens/Lyrics.dart';
import 'package:songbookapp/Screens/SongList.dart';
import 'package:songbookapp/Screens/indexScreen.dart';
import 'package:songbookapp/Screens/specialList.dart';

class AppRoute {
  Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => const Home());

      case '/list':
        return MaterialPageRoute(builder: (context) => const SongListScreen());
      case '/lyrics':
        final args = settings.arguments as Map<String, dynamic>;

        return MaterialPageRoute(
            builder: (context) => LyricsScreen(
                  fromdownloads: args['fromdownloads'],
                  mysong: args['mysong'],
                  youtube: args['youtube'],
                ));
      case '/downloads':
        return MaterialPageRoute(builder: (context) => const DownloadScreen());

      case '/index':
        return MaterialPageRoute(
          builder: (context) => Indexscreen(),
        );

      case '/letterlist':
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (context) => SongListfromIndex(letter: args['myLetter']));
      default:
        return null;
    }
  }
}
