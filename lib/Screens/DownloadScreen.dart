import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:songbookapp/logic/Hive_Service.dart';

import 'package:songbookapp/logic/model_theme.dart';

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
                            Row(
                              children: [
                                const Icon(Icons.done),
                                const SizedBox(
                                  width: 9,
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () async {
                                    await dataNotifier
                                        .deleteItem(myData[index]['maintitle']);
                                  },
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      onTap: () {
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
