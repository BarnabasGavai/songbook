import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:songbookapp/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:songbookapp/logic/Firestore_Service.dart';
import 'package:songbookapp/logic/Hive_Service.dart';
import 'package:songbookapp/logic/SearchProvider.dart';
import 'package:songbookapp/logic/connectivity_service.dart';
import 'package:songbookapp/logic/model_theme.dart';
import 'package:songbookapp/Screens/DownloadScreen.dart';
import 'package:songbookapp/Screens/HomePage.dart';
import 'package:songbookapp/Screens/Lyrics.dart';
import 'package:songbookapp/Screens/SongList.dart';
import 'package:songbookapp/logic/autocomplete_service.dart';

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
        ChangeNotifierProxyProvider<FirestoreService, SearchProvider>(
          create: (context) => SearchProvider(
              Provider.of<FirestoreService>(context, listen: false)),
          update: (context, firestoreService, previous) =>
              SearchProvider(firestoreService),
          lazy: false,
        ),
        ChangeNotifierProvider(create: (_) => AutoCOmpleteState())
      ],
      child: const MyApp(),
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
              floatingActionButtonTheme: const FloatingActionButtonThemeData(
                backgroundColor: Color(0xff141118),
                foregroundColor: Color(0xfffef7ff),
              ))
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
              floatingActionButtonTheme: const FloatingActionButtonThemeData(
                  backgroundColor: Color(0xfffef7ff),
                  foregroundColor: Color(0xff141118))),
      routes: {
        '/': (context) => const Home(),
        '/list': (context) => const SongListScreen(),
        '/lyrics': (context) => LyricsScreen(),
        '/downloads': (context) => const DownloadScreen(),
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
