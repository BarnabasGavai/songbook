import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:songbookapp/logic/Firestore_Service.dart';
import 'package:songbookapp/logic/Hive_Service.dart';

import 'package:songbookapp/logic/model_theme.dart';

class SongListfromIndex extends StatelessWidget {
  String letter;
  SongListfromIndex({super.key, required this.letter});

  @override
  Widget build(BuildContext context) {
    return Consumer3<ModelTheme, FirestoreService, HiveService>(
        builder: (context, themeNotifier, dataNotifier, localNotifier, child) {
      final data = dataNotifier.groupedItems[letter] ?? [];

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
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, "/downloads");
              },
              icon: const Icon(Icons.download_for_offline_rounded),
            ),
            const SizedBox(
              width: 15,
            )
          ],
        ),
        body: (data.isEmpty)
            ? const Center(
                child: Text(
                  "NO SONGS",
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.w400),
                ),
              )
            : ListView.builder(
                itemCount: data.length,
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
                                  ("${data[index]['title']}".length > 30)
                                      ? "${data[index]['title']}"
                                          .substring(0, 13)
                                      : "${data[index]['title']}",
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                            (localNotifier
                                    .doesItExist(data[index]['maintitle']))
                                ? const Icon(Icons.done)
                                : IconButton(
                                    onPressed: () async {
                                      await localNotifier.putItem(
                                          data[index]['maintitle'],
                                          data[index]);
                                    },
                                    icon: const Icon(Icons.download))
                          ],
                        ),
                      ),
                      onTap: () {
                        if (data[index]['hasYoutube']) {
                          Navigator.pushNamed(context, '/lyrics', arguments: {
                            "fromdownloads": false,
                            "mysong": data[index],
                            'youtube': true
                          });
                        } else {
                          Navigator.pushNamed(context, '/lyrics', arguments: {
                            "fromdownloads": false,
                            "mysong": data[index],
                            'youtube': false
                          });
                        }
                      });
                },
              ),
      );
    });
  }
}
