import 'package:flutter/material.dart';
import 'package:pinch_scale/pinch_scale.dart';
import 'package:provider/provider.dart';
import 'package:songbookapp/logic/hive_service_provider.dart';
import 'package:songbookapp/logic/model_theme.dart';
import 'package:flutter/services.dart';
import 'package:songbookapp/logic/wakelock_provider.dart';
import 'package:songbookapp/logic/youtube_player_provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class LyricsScreen extends StatelessWidget {
  final Map<dynamic, dynamic> mysong;
  final bool fromdownloads;

  final bool youtube;
  LyricsScreen(
      {super.key,
      required this.mysong,
      required this.fromdownloads,
      required this.youtube});

  final baseTextSizeValue = 18.0;

  late final fontSize = ValueNotifier<double>(baseTextSizeValue);

  void copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text)).then((_) {});
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didpop) {
        if (context.read<YoutubePlayerProvider>().isControllerReady) {
          context.read<YoutubePlayerProvider>().stop(false);
        }
        Provider.of<WakelockProvider>(context, listen: false).disableWakelock();
      },
      child: Consumer2<ModelTheme, HiveService>(
          builder: (context, themeNotifier, localNotifier, child) {
        return Scaffold(
          appBar: AppBar(
            title: (MediaQuery.of(context).size.width > 550)
                ? Text(
                    "${mysong['title']}",
                    style: const TextStyle(
                        fontSize: 23, fontWeight: FontWeight.bold),
                  )
                : const Text(""),
            centerTitle: true,
            actions: [
              IconButton(
                  icon: Icon(themeNotifier.isDark
                      ? Icons.nightlight_round
                      : Icons.wb_sunny),
                  onPressed: () {
                    themeNotifier.isDark
                        ? themeNotifier.isDark = false
                        : themeNotifier.isDark = true;
                  }),
              (fromdownloads || localNotifier.doesItExist(mysong['maintitle']))
                  ? const SizedBox(
                      width: 0,
                    )
                  : Row(
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        IconButton(
                            onPressed: () async {
                              await localNotifier.putItem(
                                  mysong['maintitle'], mysong);
                            },
                            icon: const Icon(Icons.download)),
                      ],
                    ),
              const SizedBox(
                width: 10,
              ),
              (fromdownloads || !youtube)
                  ? const SizedBox(
                      width: 0,
                    )
                  : Consumer<YoutubePlayerProvider>(
                      builder: (context, myPlayerNotifier, child) {
                      return IconButton(
                          onPressed: () {
                            if (myPlayerNotifier.isControllerReady) {
                              myPlayerNotifier.stop(true);
                            } else {
                              if ((!myPlayerNotifier.loading) ||
                                  myPlayerNotifier.isControllerReady) {
                                myPlayerNotifier
                                    .initialize("${mysong['youtube']}");
                                Future.delayed(const Duration(seconds: 3), () {
                                  myPlayerNotifier.play();
                                  Future.delayed(const Duration(seconds: 1),
                                      () {
                                    myPlayerNotifier.play();
                                    myPlayerNotifier.setLoading(false);
                                  });
                                }).then((w) {
                                  myPlayerNotifier.play();
                                });
                              }
                            }
                          },
                          icon: (myPlayerNotifier.isControllerReady)
                              ? const Icon(Icons.stop)
                              : const Icon(Icons.play_arrow));
                    }),
              const SizedBox(
                width: 15,
              )
            ],
          ),
          body: (MediaQuery.of(context).size.width > 550)
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: PinchScale(
                        baseValue: baseTextSizeValue,
                        currentValue: () => fontSize.value,
                        onValueChanged: (double newFontSize) =>
                            fontSize.value = newFontSize,
                        child: ValueListenableBuilder<double>(
                          valueListenable: fontSize,
                          builder: (context, fontSize, child) {
                            return Container(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      """${mysong['song']}""",
                                      style: TextStyle(
                                        fontSize: fontSize,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      width: (Provider.of<YoutubePlayerProvider>(context)
                              .isControllerReady)
                          ? MediaQuery.of(context).size.width * 0.5
                          : 0,
                      height: double.maxFinite,
                      child: Center(
                        child: SizedBox(
                          width: 400,
                          child: Consumer<YoutubePlayerProvider>(
                            builder: (context, myPlayerNotifier, child) {
                              return (myPlayerNotifier.isControllerReady)
                                  ? SizedBox(
                                      height: 150,
                                      child: Column(
                                        children: [
                                          // Custom Play/Pause Button
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              IconButton(
                                                onPressed: () {
                                                  myPlayerNotifier.setPosition(
                                                    Duration(
                                                      seconds: myPlayerNotifier
                                                              .position
                                                              .inSeconds -
                                                          5,
                                                    ),
                                                  );
                                                },
                                                icon: Icon(
                                                  Icons.fast_rewind,
                                                  size: 50,
                                                  color: themeNotifier.isDark
                                                      ? const Color(
                                                          0xFFE0E0E0) // Light grey for dark mode
                                                      : const Color(
                                                          0xFF2A272E), // Dark grey for light mode
                                                ),
                                              ),
                                              IconButton(
                                                icon: (myPlayerNotifier.loading)
                                                    ? SizedBox(
                                                        height: 45,
                                                        child: Center(
                                                          child:
                                                              CircularProgressIndicator(
                                                            color: (themeNotifier
                                                                    .isDark)
                                                                ? const Color(
                                                                    0xFFE0E0E0) // Light grey for dark mode
                                                                : const Color(
                                                                    0xFF2A272E), // Dark grey for light mode
                                                            backgroundColor: (themeNotifier
                                                                    .isDark)
                                                                ? const Color(
                                                                    0xFF141118) // Dark background for dark mode
                                                                : const Color(
                                                                    0xFFE0E0E0), // Light background for light mode
                                                          ),
                                                        ),
                                                      )
                                                    : (myPlayerNotifier
                                                            .isPlaying)
                                                        ? Icon(
                                                            Icons.pause,
                                                            size: 50,
                                                            color: themeNotifier
                                                                    .isDark
                                                                ? const Color(
                                                                    0xFFE0E0E0) // Light grey for dark mode
                                                                : const Color(
                                                                    0xFF2A272E), // Dark grey for light mode
                                                          )
                                                        : (myPlayerNotifier
                                                                .ended)
                                                            ? Icon(
                                                                Icons.replay,
                                                                size: 50,
                                                                color: themeNotifier
                                                                        .isDark
                                                                    ? const Color(
                                                                        0xFFE0E0E0) // Light grey for dark mode
                                                                    : const Color(
                                                                        0xFF2A272E), // Dark grey for light mode
                                                              )
                                                            : Icon(
                                                                Icons
                                                                    .play_arrow,
                                                                size: 50,
                                                                color: themeNotifier
                                                                        .isDark
                                                                    ? const Color(
                                                                        0xFFE0E0E0) // Light grey for dark mode
                                                                    : const Color(
                                                                        0xFF2A272E), // Dark grey for light mode
                                                              ),
                                                onPressed: () {
                                                  if (myPlayerNotifier
                                                      .isPlaying) {
                                                    myPlayerNotifier.pause();
                                                  } else {
                                                    if (myPlayerNotifier
                                                        .ended) {
                                                      myPlayerNotifier
                                                          .setPosition(
                                                              Duration.zero);
                                                      myPlayerNotifier.play();
                                                      myPlayerNotifier
                                                          .setEndedFalse();
                                                    } else {
                                                      myPlayerNotifier.play();
                                                    }
                                                  }
                                                },
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  myPlayerNotifier.setPosition(
                                                    Duration(
                                                      seconds: myPlayerNotifier
                                                              .position
                                                              .inSeconds +
                                                          5,
                                                    ),
                                                  );
                                                },
                                                icon: Icon(
                                                  Icons.fast_forward,
                                                  size: 50,
                                                  color: themeNotifier.isDark
                                                      ? const Color(
                                                          0xFFE0E0E0) // Light grey for dark mode
                                                      : const Color(
                                                          0xFF2A272E), // Dark grey for light mode
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            height: 30,
                                            margin: const EdgeInsets.fromLTRB(
                                                0, 10, 0, 0),
                                            child: Slider(
                                              activeColor: themeNotifier.isDark
                                                  ? const Color(
                                                      0xFFE0E0E0) // Light grey for dark mode
                                                  : const Color(
                                                      0xFF2A272E), // Dark grey for light mode
                                              inactiveColor: themeNotifier
                                                      .isDark
                                                  ? const Color(
                                                      0xFF2A272E) // Dark grey for dark mode
                                                  : const Color(
                                                      0xFFE0E0E0), // Light grey for light mode
                                              value: myPlayerNotifier
                                                  .position.inSeconds
                                                  .toDouble(),
                                              max: myPlayerNotifier
                                                  .duration.inSeconds
                                                  .toDouble(),
                                              onChanged: (value) {
                                                myPlayerNotifier.seekTo(
                                                    Duration(
                                                        seconds:
                                                            value.toInt()));
                                              },
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.fromLTRB(
                                                22, 0, 22, 0),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  myPlayerNotifier.position
                                                      .toString()
                                                      .split(".")[0]
                                                      .substring(2),
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: themeNotifier.isDark
                                                        ? const Color(
                                                            0xFFE0E0E0) // Light grey for dark mode
                                                        : const Color(
                                                            0xFF2A272E), // Dark grey for light mode
                                                  ),
                                                ),
                                                Text(
                                                  myPlayerNotifier.duration
                                                      .toString()
                                                      .split(".")[0]
                                                      .substring(2),
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: themeNotifier.isDark
                                                        ? const Color(
                                                            0xFFE0E0E0) // Light grey for dark mode
                                                        : const Color(
                                                            0xFF2A272E), // Dark grey for light mode
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : (myPlayerNotifier.loading)
                                      ? Container(
                                          height: 80,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: const Center(
                                            child: CircularProgressIndicator(
                                              backgroundColor: Color(
                                                  0xFF2A272E), // Dark grey for background
                                              valueColor:
                                                  AlwaysStoppedAnimation(Color(
                                                      0xFFE0E0E0)), // Light grey for progress
                                            ),
                                          ),
                                        )
                                      : const SizedBox(
                                          height: 0,
                                          width: 0,
                                        );
                            },
                          ),
                        ),
                      ),
                    )
                  ],
                )
              : Column(
                  children: [
                    Consumer<YoutubePlayerProvider>(
                        builder: (context, myPlayerNotifier, child) {
                      return Container(
                        child: (myPlayerNotifier.isControllerReady)
                            ? SizedBox(
                                height: 150,
                                child: Column(
                                  children: [
                                    // Custom Play/Pause Button
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            myPlayerNotifier.setPosition(
                                              Duration(
                                                  seconds: myPlayerNotifier
                                                          .position.inSeconds -
                                                      5),
                                            );
                                          },
                                          icon: Icon(
                                            Icons.fast_rewind,
                                            size: 50,
                                            color: themeNotifier.isDark
                                                ? const Color(
                                                    0xFFE0E0E0) // Light grey for dark mode
                                                : const Color(
                                                    0xFF2A272E), // Dark grey for light mode
                                          ),
                                        ),
                                        IconButton(
                                          icon: (myPlayerNotifier.loading)
                                              ? SizedBox(
                                                  height: 45,
                                                  child: Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      color: (themeNotifier
                                                              .isDark)
                                                          ? const Color(
                                                              0xFFE0E0E0) // Light grey for dark mode
                                                          : const Color(
                                                              0xFF2A272E), // Dark grey for light mode
                                                      backgroundColor: (themeNotifier
                                                              .isDark)
                                                          ? const Color(
                                                              0xFF141118) // Dark background for dark mode
                                                          : const Color(
                                                              0xFFE0E0E0), // Light background for light mode
                                                    ),
                                                  ),
                                                )
                                              : (myPlayerNotifier.isPlaying)
                                                  ? Icon(
                                                      Icons.pause,
                                                      size: 50,
                                                      color: themeNotifier
                                                              .isDark
                                                          ? const Color(
                                                              0xFFE0E0E0) // Light grey for dark mode
                                                          : const Color(
                                                              0xFF2A272E), // Dark grey for light mode
                                                    )
                                                  : (myPlayerNotifier.ended)
                                                      ? Icon(
                                                          Icons.replay,
                                                          size: 50,
                                                          color: themeNotifier
                                                                  .isDark
                                                              ? const Color(
                                                                  0xFFE0E0E0) // Light grey for dark mode
                                                              : const Color(
                                                                  0xFF2A272E), // Dark grey for light mode
                                                        )
                                                      : Icon(
                                                          Icons.play_arrow,
                                                          size: 50,
                                                          color: themeNotifier
                                                                  .isDark
                                                              ? const Color(
                                                                  0xFFE0E0E0) // Light grey for dark mode
                                                              : const Color(
                                                                  0xFF2A272E), // Dark grey for light mode
                                                        ),
                                          onPressed: () {
                                            if (myPlayerNotifier.isPlaying) {
                                              myPlayerNotifier.pause();
                                            } else {
                                              if (myPlayerNotifier.ended) {
                                                myPlayerNotifier
                                                    .setPosition(Duration.zero);
                                                myPlayerNotifier.play();
                                                myPlayerNotifier
                                                    .setEndedFalse();
                                              } else {
                                                myPlayerNotifier.play();
                                              }
                                            }
                                          },
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            myPlayerNotifier.setPosition(
                                              Duration(
                                                  seconds: myPlayerNotifier
                                                          .position.inSeconds +
                                                      5),
                                            );
                                          },
                                          icon: Icon(
                                            Icons.fast_forward,
                                            size: 50,
                                            color: themeNotifier.isDark
                                                ? const Color(
                                                    0xFFE0E0E0) // Light grey for dark mode
                                                : const Color(
                                                    0xFF2A272E), // Dark grey for light mode
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      height: 30,
                                      margin: const EdgeInsets.fromLTRB(
                                          0, 10, 0, 0),
                                      child: Slider(
                                        activeColor: themeNotifier.isDark
                                            ? const Color(
                                                0xFFE0E0E0) // Light grey for dark mode
                                            : const Color(
                                                0xFF2A272E), // Dark grey for light mode
                                        inactiveColor: themeNotifier.isDark
                                            ? const Color(
                                                0xFF2A272E) // Dark grey for dark mode
                                            : const Color(
                                                0xFFE0E0E0), // Light grey for light mode
                                        value: myPlayerNotifier
                                            .position.inSeconds
                                            .toDouble(),
                                        max: myPlayerNotifier.duration.inSeconds
                                            .toDouble(),
                                        onChanged: (value) {
                                          myPlayerNotifier.seekTo(
                                              Duration(seconds: value.toInt()));
                                        },
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          22, 0, 22, 0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            myPlayerNotifier.position
                                                .toString()
                                                .split(".")[0]
                                                .substring(2),
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: themeNotifier.isDark
                                                  ? const Color(
                                                      0xFFE0E0E0) // Light grey for dark mode
                                                  : const Color(
                                                      0xFF2A272E), // Dark grey for light mode
                                            ),
                                          ),
                                          Text(
                                            myPlayerNotifier.duration
                                                .toString()
                                                .split(".")[0]
                                                .substring(2),
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: themeNotifier.isDark
                                                  ? const Color(
                                                      0xFFE0E0E0) // Light grey for dark mode
                                                  : const Color(
                                                      0xFF2A272E), // Dark grey for light mode
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : (myPlayerNotifier.loading)
                                ? Container(
                                    height: 80,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: const Center(
                                      child: CircularProgressIndicator(
                                        backgroundColor: Color(
                                            0xFF2A272E), // Dark grey for background
                                        valueColor: AlwaysStoppedAnimation(Color(
                                            0xFFE0E0E0)), // Light grey for progress
                                      ),
                                    ),
                                  )
                                : const SizedBox(
                                    height: 0,
                                  ),
                      );
                    }),
                    Flexible(
                      child: PinchScale(
                        baseValue: baseTextSizeValue,
                        currentValue: () => fontSize.value,
                        onValueChanged: (double newFontSize) =>
                            fontSize.value = newFontSize,
                        child: ValueListenableBuilder<double>(
                          valueListenable: fontSize,
                          builder: (context, fontSize, child) {
                            return Container(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: Text(
                                        "${mysong['title']}",
                                        style: const TextStyle(
                                            fontSize: 23,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    Text(
                                      """${mysong['song']}""",
                                      style: TextStyle(
                                          fontSize: fontSize,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              copyToClipboard(mysong['song']);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Text copied to clipboard')),
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Consumer<YoutubePlayerProvider>(
                  builder: (context, myPlayerNotifier, child) =>
                      (myPlayerNotifier.isControllerReady)
                          ? Flexible(
                              child: Opacity(
                                opacity: 0,
                                child: SizedBox(
                                  height: 0,
                                  width: 0,
                                  child: YoutubePlayer(
                                    aspectRatio:
                                        0.000000000000000000000000000000001,
                                    controller: myPlayerNotifier.controller,
                                    showVideoProgressIndicator: false,
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox(
                              height: 0,
                              width: 0,
                            ),
                ),
                const Icon(Icons.copy)
              ],
            ),
          ),
        );
      }),
    );
  }
}
