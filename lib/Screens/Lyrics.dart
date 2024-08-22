import 'package:flutter/material.dart';
import 'package:pinch_scale/pinch_scale.dart';
import 'package:provider/provider.dart';
import 'package:songbookapp/logic/Hive_Service.dart';
import 'package:songbookapp/logic/model_theme.dart';
import 'package:flutter/services.dart';
import 'package:songbookapp/logic/youtubePlayer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class LyricsScreen extends StatefulWidget {
  Map<dynamic, dynamic> mysong;
  bool fromdownloads;
  bool youtube;
  LyricsScreen(
      {super.key,
      required this.mysong,
      required this.fromdownloads,
      required this.youtube});

  @override
  State<LyricsScreen> createState() => _LyricsScreenState();
}

class _LyricsScreenState extends State<LyricsScreen> {
  final baseTextSizeValue = 18.0;

  late final fontSize = ValueNotifier<double>(baseTextSizeValue);

  void copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text)).then((_) {
      print('Song copied to clipboard');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<ModelTheme, HiveService, YoutubePlayerProvider>(builder:
        (context, themeNotifier, localNotifier, myPlayerNotifier, child) {
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
            (widget.fromdownloads ||
                    localNotifier.doesItExist(widget.mysong['maintitle']))
                ? const SizedBox(
                    width: 0,
                  )
                : Column(
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      IconButton(
                          onPressed: () async {
                            await localNotifier.putItem(
                                widget.mysong['maintitle'], widget.mysong);
                          },
                          icon: const Icon(Icons.download)),
                    ],
                  ),
            const SizedBox(
              width: 10,
            ),
            (widget.fromdownloads || !widget.youtube)
                ? const SizedBox(
                    width: 0,
                  )
                : IconButton(
                    onPressed: () {
                      if (myPlayerNotifier.isControllerReady) {
                        if (myPlayerNotifier.isPlaying) {
                          myPlayerNotifier.stop();
                        } else {
                          myPlayerNotifier.play();
                        }
                      } else {
                        if ((!myPlayerNotifier.loading) ||
                            myPlayerNotifier.isControllerReady) {
                          myPlayerNotifier.initialize(widget.mysong['youtube']);
                          Future.delayed(const Duration(seconds: 6), () {
                            myPlayerNotifier.play();
                          });
                        }
                      }
                    },
                    icon: (myPlayerNotifier.isPlaying)
                        ? const Icon(Icons.stop)
                        : const Icon(Icons.play_arrow)),
            const SizedBox(
              width: 10,
            )
          ],
        ),
        body: Column(
          children: [
            (myPlayerNotifier.isControllerReady)
                ? Container(
                    height: 150,
                    child: Column(
                      children: [
                        // Custom Play/Pause Button
                        IconButton(
                          icon: (myPlayerNotifier.isPlaying)
                              ? const Icon(
                                  Icons.pause,
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
                              myPlayerNotifier.play();
                            }
                          },
                        ),

                        Slider(
                          activeColor: (themeNotifier.isDark)
                              ? Color(0xfffef7ff)
                              : Color(0xff141118),
                          value: myPlayerNotifier.position.inSeconds.toDouble(),
                          max: myPlayerNotifier.duration.inSeconds.toDouble(),
                          onChanged: (value) {
                            myPlayerNotifier
                                .seekTo(Duration(seconds: value.toInt()));
                          },
                        ),

                        Flexible(
                          child: Opacity(
                            opacity: 0,
                            child: YoutubePlayer(
                              aspectRatio: 0.000000000000000001,
                              controller: myPlayerNotifier.controller,
                              showVideoProgressIndicator: false,
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                : (myPlayerNotifier.loading)
                    ? Center(
                        child: Container(
                          height: 80,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: const CircularProgressIndicator(
                            backgroundColor: Colors.white,
                            valueColor: AlwaysStoppedAnimation(Colors.black),
                          ),
                        ),
                      )
                    : const SizedBox(
                        height: 0,
                      ),
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
                                "${widget.mysong['title']}",
                                style: const TextStyle(
                                    fontSize: 23, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Text(
                              """${widget.mysong['song']}""",
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
            copyToClipboard(widget.mysong['song']);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Text copied to clipboard')),
            );
          },
          child: const Icon(Icons.copy),
        ),
      );
    });
  }
}
