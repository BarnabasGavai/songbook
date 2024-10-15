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
  late final autoplayercontroller;
  late final firestorenotifier;
  List _ids = [];
  int choose = 0;
  void choosing() {
    bool check = true;
    while (check) {
      choose = Random().nextInt(firestorenotifier.data.length);
      if (firestorenotifier.data[choose]["hasYoutube"]) {
        check = false;
      }
    }

    setState(() {
      choose;
    });
  }

  void for_next_song() {
    choosing();

    autoplayercontroller.controller.load(_ids[choose]);
  }

  @override
  void initState() {
    super.initState();
    autoplayercontroller = context.read<AutoplayProvider>();
    firestorenotifier = context.read<FirestoreService>();
    int i = 0;
    int maxCount = firestorenotifier.data.length;

    choosing();

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

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        autoplayercontroller
            .dispose_controller(); // Dispose of the old controller when navigating back
        Provider.of<WakelockProvider>(context, listen: false).disableWakelock();
      },
      child: Consumer4<ModelTheme, HiveService, AutoplayProvider,
              FirestoreService>(
          builder: (context, themeNotifier, localNotifier, myPlayerNotifier,
              firestoreNotifier, child) {
        Widget player = NonstopPlayer(
            mysong: firestoreNotifier.data[choose], fromdownloads: false);

        return Scaffold(
          body: Stack(
            children: [
              if (myPlayerNotifier.isControllerReady)
                Container(
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
                            } catch (e) {}
                          }
                        },
                      ),
                    ),
                  ),
                )
              else
                SizedBox(height: 0, width: 0),
              player
            ],
          ),
        );
      }),
    );
  }
}
