import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:songbookapp/logic/hive_service_provider.dart';

import 'package:songbookapp/logic/model_theme.dart';
import 'package:songbookapp/logic/wakelock_provider.dart';

class DownloadScreen extends StatelessWidget {
  const DownloadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ModelTheme, HiveService>(
        builder: (context, themeNotifier, dataNotifier, child) {
      List<Map<dynamic, dynamic>> myData = dataNotifier.getAllItems();
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Offline Downloads",
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
          ),
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
            )
          ],
        ),
        body: (myData.isEmpty)
            ? const Center(
                child: Text(
                  "NO SONGS",
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.w400),
                ),
              )
            : ListView.builder(
                itemCount: myData.length,
                itemBuilder: (context, index) {
                  return InkWell(
                      child: Container(
                        color: themeNotifier.isDark
                            ? (index % 2 == 0)
                                ? const Color(0xFF1C1A22)
                                : const Color(0xFF2A272E)
                            : (index % 2 == 0)
                                ? const Color(0xFFF7F7F7)
                                : const Color(0xFFEFEFEF),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 4),
                        height: 60,
                        padding: const EdgeInsets.fromLTRB(17, 10, 17, 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Icon(Icons.music_note),
                                const SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  ("${myData[index]['title']}".length > 30)
                                      ? "${myData[index]['title']}"
                                          .substring(0, 13)
                                      : "${myData[index]['title']}",
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                                await dataNotifier
                                    .deleteItem(myData[index]['maintitle']);
                              },
                            )
                          ],
                        ),
                      ),
                      onTap: () {
                        Provider.of<WakelockProvider>(context, listen: false)
                            .enableWakelock();

                        Navigator.pushNamed(context, '/lyrics', arguments: {
                          "fromdownloads": true,
                          "mysong": myData[index],
                          'youtube': false
                        });
                      });
                },
              ),
      );
    });
  }
}
