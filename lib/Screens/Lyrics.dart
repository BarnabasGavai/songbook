import 'package:flutter/material.dart';
import 'package:pinch_scale/pinch_scale.dart';
import 'package:provider/provider.dart';
import 'package:songbookapp/logic/Hive_Service.dart';
import 'package:songbookapp/logic/model_theme.dart';
import 'package:flutter/services.dart';

class LyricsScreen extends StatelessWidget {
  final baseTextSizeValue = 18.0;
  late final fontSize = ValueNotifier<double>(baseTextSizeValue);
  Map<dynamic, dynamic> mysong;
  bool fromdownloads;
  LyricsScreen({super.key, required this.mysong, required this.fromdownloads});
  void copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text)).then((_) {
      print('Song copied to clipboard');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ModelTheme, HiveService>(
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
            const SizedBox(
              width: 15,
            ),
            (fromdownloads || localNotifier.doesItExist(mysong['maintitle']))
                ? SizedBox(
                    width: 0,
                  )
                : IconButton(
                    onPressed: () async {
                      await localNotifier.putItem(mysong['maintitle'], mysong);
                    },
                    icon: Icon(Icons.download)),
            const SizedBox(
              width: 15,
            )
          ],
        ),
        body: PinchScale(
          baseValue: baseTextSizeValue,
          currentValue: () => fontSize.value,
          onValueChanged: (double newFontSize) => fontSize.value = newFontSize,
          child: ValueListenableBuilder<double>(
            valueListenable: fontSize,
            builder: (context, fontSize, child) {
              return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          "${mysong['title']}",
                          style: TextStyle(
                              fontSize: 23, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        """${mysong['song']}""",
                        style: TextStyle(
                            fontSize: fontSize, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            copyToClipboard(mysong['song']);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Text copied to clipboard')),
            );
          },
          child: Icon(Icons.copy),
        ),
      );
    });
  }
}
