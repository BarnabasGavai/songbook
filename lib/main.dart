import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:songbookapp/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:songbookapp/logic/autoplay_provider.dart';
import 'package:songbookapp/logic/firestore_service.dart';
import 'package:songbookapp/logic/hive_service_provider.dart';
import 'package:songbookapp/logic/search_provider.dart';
import 'package:songbookapp/logic/connectivity_service.dart';
import 'package:songbookapp/logic/model_theme.dart';
import 'package:songbookapp/logic/autocomplete_service.dart';
import 'package:songbookapp/logic/wakelock_provider.dart';
import 'package:songbookapp/logic/youtube_player_provider.dart';
import 'package:songbookapp/router.dart';

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
        ChangeNotifierProvider(create: (_) => AutoplayProvider()),
        ChangeNotifierProvider(create: (_) => YoutubePlayerProvider()),
        ChangeNotifierProvider(create: (_) => WakelockProvider()),
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
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  final AppRoute _appRoute = AppRoute();
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final modelTheme = Provider.of<ModelTheme>(context);

    return MaterialApp(
      title: "SongBook App",
      debugShowCheckedModeBanner: false,
      theme: (modelTheme.isDark)
          ? ThemeData(
              pageTransitionsTheme: const PageTransitionsTheme(
                  builders: <TargetPlatform, PageTransitionsBuilder>{
                    TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
                  }),
              textSelectionTheme: const TextSelectionThemeData(
                cursorColor:
                    Color(0xFFFAFAFA), // Slightly off-white for dark mode
              ),
              brightness: Brightness.dark,
              scaffoldBackgroundColor: const Color(
                  0xFF141118), // Main background color for dark mode
              appBarTheme: const AppBarTheme(
                elevation: 0, // Ensures no elevation
                scrolledUnderElevation: 0, // Prevents shadow during scrolling
                backgroundColor:
                    Colors.transparent, // Keeps AppBar transparent in dark mode
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  statusBarIconBrightness:
                      Brightness.light, // Light status bar icons for dark mode
                  systemNavigationBarColor: Color(0xFF141118),
                  systemNavigationBarIconBrightness: Brightness.light,
                ),
                foregroundColor: Color(
                    0xFFFAFAFA), // AppBar icon and text color for dark mode
              ),
              floatingActionButtonTheme: const FloatingActionButtonThemeData(
                backgroundColor:
                    Color(0xFF2F2C33), // Slightly lighter gray for contrast
                foregroundColor: Color(0xFFFAFAFA), // Off-white for icons
              ),
              cardColor: const Color(
                  0xFF2A272E), // Background color for list items in dark mode
              dividerColor:
                  const Color(0xFF1C191F), // Subtle divider for separation
              textTheme: const TextTheme(
                bodyLarge: TextStyle(
                    color: Color(0xFFFAFAFA)), // Light text on dark background
                bodyMedium: TextStyle(color: Color(0xFFFAFAFA)),
              ),
              colorScheme: const ColorScheme.dark(
                primary: Colors
                    .transparent, // Ensures no violet or other color overlays
              ),
            )
          : ThemeData(
              pageTransitionsTheme: const PageTransitionsTheme(
                  builders: <TargetPlatform, PageTransitionsBuilder>{
                    TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
                  }),
              textSelectionTheme: const TextSelectionThemeData(
                cursorColor: Color(0xFF141118), // Dark cursor for light mode
              ),
              brightness: Brightness.light,
              scaffoldBackgroundColor:
                  const Color(0xFFFDFDFD), // Slightly off-white for light mode
              appBarTheme: const AppBarTheme(
                elevation: 0, // Prevents any shadow or elevation when scrolling
                scrolledUnderElevation: 0, // Removes shadow during scroll
                backgroundColor:
                    Colors.transparent, // Keeps the AppBar transparent
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  statusBarIconBrightness:
                      Brightness.dark, // Dark status bar icons for light mode
                  systemNavigationBarColor:
                      Color(0xFFFDFDFD), // Matches scaffold background
                  systemNavigationBarIconBrightness: Brightness.dark,
                ),
                foregroundColor: Color(
                    0xFF141118), // AppBar icon and text color for light mode
              ),
              floatingActionButtonTheme: const FloatingActionButtonThemeData(
                backgroundColor:
                    Color(0xFFEDEDED), // Slightly darker gray for contrast
                foregroundColor:
                    Color(0xFF141118), // Dark icons for floating button
              ),
              cardColor: const Color(
                  0xFFEDEDED), // Light gray background for list items in light mode
              dividerColor:
                  const Color(0xFFF5F5F5), // Subtle divider for separation
              textTheme: const TextTheme(
                bodyLarge: TextStyle(
                    color: Color(0xFF141118)), // Dark text on light background
                bodyMedium: TextStyle(color: Color(0xFF141118)),
              ),
              colorScheme: const ColorScheme.light(
                primary:
                    Colors.transparent, // Ensures no violet or other overlays
              ),
            ),
      onGenerateRoute: _appRoute.onGenerateRoute,
    );
  }
}
