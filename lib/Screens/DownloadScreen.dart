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
            SizedBox(
              width: 20,
            )
          ],
        ),
        body: (myData.length < 1)
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
                                  ("${myData[index]['title']}".length > 30)
                                      ? "${myData[index]['title']}"
                                          .substring(0, 13)
                                      : "${myData[index]['title']}",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.done),
                                SizedBox(
                                  width: 9,
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
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
                        Navigator.pushNamed(context, '/lyrics',
                            arguments: myData[index]);
                      });
                },
              ),
      );
    });
  }
}
