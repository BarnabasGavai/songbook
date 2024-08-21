import 'package:flutter/material.dart';
import 'package:songbookapp/Screens/DownloadScreen.dart';
import 'package:songbookapp/Screens/HomePage.dart';
import 'package:songbookapp/Screens/Lyrics.dart';
import 'package:songbookapp/Screens/SongList.dart';

class AppRoute {
  Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => Home());

      case '/list':
        return MaterialPageRoute(builder: (context) => SongListScreen());
      case '/lyrics':
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (context) => LyricsScreen(
                  fromdownloads: args['fromdownloads'],
                  mysong: args['mysong'],
                ));
      case '/downloads':
        return MaterialPageRoute(builder: (context) => DownloadScreen());
      default:
        return null;
    }
  }
}
