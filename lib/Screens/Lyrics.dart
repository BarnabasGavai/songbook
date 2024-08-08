import 'package:flutter/material.dart';
import 'package:pinch_scale/pinch_scale.dart';
import 'package:provider/provider.dart';
import 'package:songbookapp/logic/model_theme.dart';
import 'package:flutter/services.dart';

class LyricsScreen extends StatelessWidget {
  final baseTextSizeValue = 18.0;
  late final fontSize = ValueNotifier<double>(baseTextSizeValue);
  LyricsScreen({super.key});
  void copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text)).then((_) {
      print('Song copied to clipboard');
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map<dynamic, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<dynamic, dynamic>;
    return Consumer<ModelTheme>(builder: (context, themeNotifier, child) {
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
              width: 20,
            ),
            const Icon(Icons.download_for_offline_rounded),
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
                          "${args['title']}",
                          style: TextStyle(
                              fontSize: 23, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        """${args['song']}""",
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
            copyToClipboard(args['song']);
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
