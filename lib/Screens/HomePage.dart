import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:songbookapp/Screens/DownloadScreen.dart';
import 'package:songbookapp/logic/Firestore_Service.dart';
import 'package:songbookapp/logic/connectivity_service.dart';

import 'package:songbookapp/logic/model_theme.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer3<ModelTheme, ConnectivityService, FirestoreService>(builder:
        (context, themeNotifier, internetNotifier, dataNotifier, child) {
      if (internetNotifier.isConnected) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Scaffold(
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
                    icon: const Icon(Icons.download_for_offline)),
                const SizedBox(
                  width: 15,
                )
              ],
            ),
            body: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      "Praise the Lord!",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: const Text(
                        "Make a joyful noise unto the Lord, all ye lands. Serve the Lord with gladness: come before his presence with singing.\n Psalm 100: 1-2",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: SearchBar(
                        trailing: [Icon(Icons.search)],
                        padding: WidgetStatePropertyAll(
                            EdgeInsets.symmetric(horizontal: 20)),
                        hintText: "Search the song here",
                        backgroundColor:
                            WidgetStatePropertyAll(Colors.transparent),
                        shadowColor: WidgetStatePropertyAll(Colors.transparent),
                        side: WidgetStatePropertyAll(
                            BorderSide(color: Colors.grey)),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Container(
                      height: 40,
                      margin: const EdgeInsets.symmetric(horizontal: 30),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: (themeNotifier.isDark)
                                  ? Colors.white
                                  : Colors.black),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15))),
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/list');
                        },
                        child: const Center(
                          child: Text(
                            "Hindi Songs",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16.4),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      } else {
        return const Scaffold(
          body: Center(
            child: DownloadScreen(),
          ),
        );
      }
    });
  }
}
