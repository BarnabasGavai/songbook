import 'package:flutter/material.dart';
import 'package:pinch_scale/pinch_scale.dart';
import 'package:provider/provider.dart';
import 'package:songbookapp/logic/Hive_Service.dart';
import 'package:songbookapp/logic/model_theme.dart';
import 'package:flutter/services.dart';
import 'package:songbookapp/logic/youtubePlayer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class LyricsScreen extends StatelessWidget {
  Map<dynamic, dynamic> mysong;
  bool fromdownloads;

  bool youtube;
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
      },
      child: Consumer2<ModelTheme, HiveService>(
          builder: (context, themeNotifier, localNotifier, child) {
        return Scaffold(
          appBar: AppBar(
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
                                    myPlayerNotifier.setLoading(false);
                                  });
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
          body: Column(
            children: [
              Consumer<YoutubePlayerProvider>(
                  builder: (context, myPlayerNotifier, child) {
                return Container(
                  child: (myPlayerNotifier.isControllerReady)
                      ? Container(
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
                                        myPlayerNotifier.setPosition(Duration(
                                            seconds: myPlayerNotifier
                                                    .position.inSeconds -
                                                5));
                                      },
                                      icon: const Icon(
                                        Icons.fast_rewind,
                                        size: 50,
                                      )),
                                  IconButton(
                                    icon: (myPlayerNotifier.loading)
                                        ? Container(
                                            height: 45,
                                            child: Center(
                                              child: CircularProgressIndicator(
                                                color: (themeNotifier.isDark)
                                                    ? const Color(0xfffef7ff)
                                                    : const Color(0xff141118),
                                                backgroundColor: (!themeNotifier
                                                        .isDark)
                                                    ? const Color(0xfffef7ff)
                                                    : const Color(0xff141118),
                                              ),
                                            ),
                                          )
                                        : (myPlayerNotifier.isPlaying)
                                            ? const Icon(
                                                Icons.pause,
                                                size: 50,
                                              )
                                            : (myPlayerNotifier.ended)
                                                ? const Icon(
                                                    Icons.replay,
                                                    size: 50,
                                                  )
                                                : const Icon(
                                                    Icons.play_arrow,
                                                    size: 50,
                                                  ),
                                    onPressed: () {
                                      if (myPlayerNotifier.isPlaying) {
                                        myPlayerNotifier.pause();
                                      } else {
                                        if (myPlayerNotifier.ended) {
                                          myPlayerNotifier
                                              .setPosition(Duration.zero);
                                          myPlayerNotifier.play();
                                          myPlayerNotifier.setEndedFalse();
                                        } else {
                                          myPlayerNotifier.play();
                                        }
                                      }
                                    },
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        myPlayerNotifier.setPosition(Duration(
                                            seconds: myPlayerNotifier
                                                    .position.inSeconds +
                                                5));
                                      },
                                      icon: const Icon(
                                        Icons.fast_forward,
                                        size: 50,
                                      ))
                                ],
                              ),

                              Container(
                                height: 30,
                                margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                child: Slider(
                                  activeColor: (themeNotifier.isDark)
                                      ? const Color(0xfffef7ff)
                                      : const Color(0xff141118),
                                  value: myPlayerNotifier.position.inSeconds
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
                                padding:
                                    const EdgeInsets.fromLTRB(22, 0, 22, 0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${myPlayerNotifier.position.toString().split(".")[0].substring(2)}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      "${myPlayerNotifier.duration.toString().split(".")[0].substring(2)}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),

                              Flexible(
                                child: Opacity(
                                  opacity: 0,
                                  child: Container(
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
                            ],
                          ),
                        )
                      : (myPlayerNotifier.loading)
                          ? Container(
                              height: 80,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: const Center(
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.white,
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.black),
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
            child: const Icon(Icons.copy),
          ),
        );
      }),
    );
  }
}
