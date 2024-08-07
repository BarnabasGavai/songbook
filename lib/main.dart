import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:songbookapp/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:songbookapp/logic/Firestore_Service.dart';
import 'package:songbookapp/logic/Hive_Service.dart';
import 'package:songbookapp/logic/connectivity_service.dart';
import 'package:songbookapp/logic/model_theme.dart';
import 'package:songbookapp/Screens/DownloadScreen.dart';
import 'package:songbookapp/Screens/HomePage.dart';
import 'package:songbookapp/Screens/Lyrics.dart';
import 'package:songbookapp/Screens/SongList.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //initialize firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseFirestore.instance.settings =
      const Settings(persistenceEnabled: false);

  //initialize Hive
  await Hive.initFlutter();
  Box mybox = await Hive.openBox('myBox');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => HiveService(mybox: mybox), lazy: false),
        ChangeNotifierProvider(
            create: (_) => ConnectivityService(), lazy: false),
        ChangeNotifierProvider(create: (_) => FirestoreService(), lazy: false),
        ChangeNotifierProvider(create: (_) => ModelTheme(), lazy: false),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final modelTheme = Provider.of<ModelTheme>(context);

    return MaterialApp(
      title: "SongBook App",
      debugShowCheckedModeBanner: false,
      theme: (modelTheme.isDark)
          ? ThemeData(
              brightness: Brightness.dark,
              appBarTheme: const AppBarTheme(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  systemOverlayStyle: SystemUiOverlayStyle(
                      statusBarColor: Colors.transparent,
                      statusBarIconBrightness: Brightness.light,
                      systemNavigationBarColor: Color(0xff141118),
                      systemNavigationBarIconBrightness: Brightness.light)),
            )
          : ThemeData(
              brightness: Brightness.light,
              appBarTheme: const AppBarTheme(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  systemOverlayStyle: SystemUiOverlayStyle(
                      statusBarColor: Colors.transparent,
                      statusBarIconBrightness: Brightness.dark,
                      systemNavigationBarColor: Color(0xfffef7ff),
                      systemNavigationBarIconBrightness: Brightness.dark)),
            ),
      routes: {
        '/': (context) => Home(),
        '/list': (context) => SongListScreen(),
        '/lyrics': (context) => LyricsScreen(),
        '/downloads': (context) => DownloadScreen(),
      },
    );
  }
}

// class ConnectivityChecker extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final connectivityService =
//         Provider.of<ConnectivityService>(context, listen: false);

//     return FutureBuilder<void>(
//       future: connectivityService.initialization,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Scaffold(
//             body: Center(child: CircularProgressIndicator()),
//           );
//         } else if (snapshot.hasError || !connectivityService.isConnected) {
//           return DownloadScreen(); // Show fallback screen when offline
//         } else {
//           return Home(); // Main screen when online
//         }
//       },
//     );
//   }
// }
