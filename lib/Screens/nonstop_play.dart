import 'package:flutter/material.dart';
import 'package:pinch_scale/pinch_scale.dart';
import 'package:provider/provider.dart';

import 'package:songbookapp/logic/firestore_service.dart';
import 'package:songbookapp/logic/hive_service_provider.dart';
import 'package:songbookapp/logic/model_theme.dart';
import 'package:flutter/services.dart';
import 'package:songbookapp/logic/wakelock_provider.dart';

class NonstopPlayer extends StatelessWidget {
  final Map<dynamic, dynamic> mysong;
  final bool fromdownloads;

  NonstopPlayer({
    super.key,
    required this.mysong,
    required this.fromdownloads,
  });

  final baseTextSizeValue = 18.0;

  late final fontSize = ValueNotifier<double>(baseTextSizeValue);

  void copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text)).then((_) {});
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<ModelTheme, HiveService, FirestoreService>(builder:
        (context, themeNotifier, localNotifier, firestoreNotifier, child) {
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
            const SizedBox(
              width: 5,
            ),
          ],
        ),
        body: (MediaQuery.of(context).size.width > 550)
            ? Container(
                child: SingleChildScrollView(
                  child: Center(
                    child: PinchScale(
                      baseValue: baseTextSizeValue,
                      currentValue: () => fontSize.value,
                      onValueChanged: (double newFontSize) =>
                          fontSize.value = newFontSize,
                      child: ValueListenableBuilder<double>(
                        valueListenable: fontSize,
                        builder: (context, fontSize, child) {
                          return Container(
                            child: Text(
                              """${mysong['song']}""",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: fontSize,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              )
            : Column(
                children: [
                  const SizedBox(
                    height: 15,
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
    });
  }
}
