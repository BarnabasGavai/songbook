import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:songbookapp/logic/Firestore_Service.dart';
import 'package:songbookapp/logic/Hive_Service.dart';

import 'package:songbookapp/logic/model_theme.dart';

class SongListScreen extends StatelessWidget {
  const SongListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer3<ModelTheme, FirestoreService, HiveService>(
        builder: (context, themeNotifier, dataNotifier, localNotifier, child) {
      final data = dataNotifier.data;

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
            SizedBox(
              width: 20,
            ),
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, "/downloads");
              },
              icon: Icon(Icons.download_for_offline_rounded),
            ),
            SizedBox(
              width: 15,
            )
          ],
        ),
        body: (data.length < 1)
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
                        padding: EdgeInsets.fromLTRB(17, 10, 17, 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(Icons.music_note),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  ("${data[index]['title']}".length > 30)
                                      ? "${data[index]['title']}"
                                          .substring(0, 13)
                                      : "${data[index]['title']}",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                            (localNotifier
                                    .doesItExist(data[index]['maintitle']))
                                ? Icon(Icons.done)
                                : IconButton(
                                    onPressed: () async {
                                      await localNotifier.putItem(
                                          data[index]['maintitle'],
                                          data[index]);
                                    },
                                    icon: Icon(Icons.download))
                          ],
                        ),
                      ),
                      onTap: () {
                        if (data[index].containsKey('youtube')) {
                          Navigator.pushNamed(context, '/lyrics', arguments: {
                            "fromdownloads": false,
                            "mysong": data[index],
                            'youtube': true
                          });
                        }
                        Navigator.pushNamed(context, '/lyrics', arguments: {
                          "fromdownloads": false,
                          "mysong": data[index],
                          'youtube': false
                        });
                      });
                },
              ),
      );
    });
  }
}
