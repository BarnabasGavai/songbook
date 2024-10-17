import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:songbookapp/Screens/nonstop_play.dart';
import 'package:songbookapp/logic/autoplay_provider.dart';
import 'package:songbookapp/logic/firestore_service.dart';
import 'package:songbookapp/logic/model_theme.dart';
import 'package:songbookapp/logic/wakelock_provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../logic/hive_service_provider.dart';

class NonstopController extends StatefulWidget {
  const NonstopController({super.key});

  @override
  State<NonstopController> createState() => _NonstopControllerState();
}

class _NonstopControllerState extends State<NonstopController> {
  bool myLoading = false; // Renamed for clarity
  // ignore: prefer_typing_uninitialized_variables
  late final autoplayercontroller;
  // ignore: prefer_typing_uninitialized_variables
  late final firestorenotifier;
  final List _ids = [];
  int choose = -1;
  void choosing() {
    bool check = true;
    while (check) {
      int mycount = firestorenotifier.data.length;
      if (mycount > 0) {
        choose = Random().nextInt(mycount);
      } else {
        check = false;
        break;
      }
      if (firestorenotifier.data[choose]["hasYoutube"]) {
        check = false;
      }
    }

    setState(() {
      choose;
    });
  }

  void checker() {
    if (firestorenotifier.data.length > 0) {
      loadSongs();
      firestorenotifier.removeListener(checker);
      return;
    }
  }

  void for_next_song() {
    choosing();

    autoplayercontroller.controller.load(_ids[choose]);
  }

  void loadSongs() {
    int i = 0;
    int maxCount = firestorenotifier.data.length;

    choosing();
    if (choose == -1) {
      firestorenotifier.addListener(checker);
      return;
    }
    while (i < maxCount) {
      String yotubeid = firestorenotifier.data[i]["youtube"];

      _ids.add(yotubeid);
      i++;
    }
    setState(() {});

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!autoplayercontroller.isControllerReady) {
        String videoId = firestorenotifier.data[choose]['youtube'];
        autoplayercontroller
            .initialize(videoId); // Initialize with the newly chosen video ID
      } else {
        // If the controller was already initialized, load the new video
        autoplayercontroller.controller
            .load(firestorenotifier.data[choose]['youtube']);
      }
    });
  }

  bool isloaded = false;

  @override
  void initState() {
    super.initState();
    autoplayercontroller = context.read<AutoplayProvider>();
    firestorenotifier = context.read<FirestoreService>();
    loadSongs();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        if (choose != -1) {
          autoplayercontroller.disposeController();
        } // Dispose of the old controller when navigating back
        Provider.of<WakelockProvider>(context, listen: false).disableWakelock();
      },
      child: Consumer4<ModelTheme, HiveService, AutoplayProvider,
              FirestoreService>(
          builder: (context, themeNotifier, localNotifier, myPlayerNotifier,
              firestoreNotifier, child) {
        Widget circle = Scaffold(
          body: Center(
            child: CircularProgressIndicator(
              color: (themeNotifier.isDark)
                  ? const Color(0xFFE0E0E0) // Light grey for dark mode
                  : const Color(0xFF2A272E), // Dark grey for light mode
              backgroundColor: (themeNotifier.isDark)
                  ? const Color(0xFF141118) // Dark background for dark mode
                  : const Color(0xFFE0E0E0), // Light background for light mode
            ),
          ),
        );
        Widget player = const SizedBox(height: 0, width: 0);
        if (myPlayerNotifier.isControllerReady || choose != -1) {
          player = NonstopPlayer(
              mysong: firestoreNotifier.data[choose], fromdownloads: false);
          isloaded = true;
        } else {
          isloaded = false;
        }

        Widget mainwidget = (isloaded) ? player : circle;

        return Scaffold(
          body: Stack(
            children: [
              if (myPlayerNotifier.isControllerReady)
                SizedBox(
                  height: 0,
                  width: 0,
                  child: Opacity(
                    opacity: 0,
                    child: SizedBox(
                      height: 0,
                      width: 0,
                      child: YoutubePlayer(
                        aspectRatio:
                            0.000000000000000000000000000000000000000000000000000000000001,
                        controller: myPlayerNotifier.controller,
                        showVideoProgressIndicator: false,
                        onEnded: (data) {
                          bool problem = true;
                          while (problem) {
                            try {
                              for_next_song();
                              problem = false;
                            } catch (e) {
                              //m
                            }
                          }
                        },
                      ),
                    ),
                  ),
                )
              else
                const SizedBox(height: 0, width: 0),
              mainwidget
            ],
          ),
        );
      }),
    );
  }
}
