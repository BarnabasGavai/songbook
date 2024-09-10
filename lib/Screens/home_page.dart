import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:songbookapp/Screens/download_screen.dart';
import 'package:songbookapp/Screens/searching_screen.dart';
import 'package:songbookapp/logic/firestore_service.dart';

import 'package:songbookapp/logic/connectivity_service.dart';

import 'package:songbookapp/logic/model_theme.dart';
import 'package:songbookapp/logic/autocomplete_service.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer4<ModelTheme, ConnectivityService, FirestoreService,
            AutoCOmpleteState>(
        builder: (context, themeNotifier, internetNotifier, dataNotifier,
            autocompleteNotifier, child) {
      if (internetNotifier.isConnected) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
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
                      FocusManager.instance.primaryFocus?.unfocus();
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
                          TextStyle(fontSize: 33, fontWeight: FontWeight.bold),
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
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const Searchingscreen(),
                          transitionDuration: Duration.zero,
                          reverseTransitionDuration: Duration.zero,
                        ),
                      ),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: 45,
                        decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: (themeNotifier.isDark)
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(20)),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Search the song here"),
                              Icon(Icons.search)
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width * 0.75,
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
                          FocusManager.instance.primaryFocus?.unfocus();
                          Navigator.pushNamed(context, '/index');
                        },
                        child: const Center(
                          child: Text(
                            "Letter Index",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16.4),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width * 0.75,
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
                          FocusManager.instance.primaryFocus?.unfocus();
                          Navigator.pushNamed(context, '/list');
                        },
                        child: const Center(
                          child: Text(
                            "All Songs",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16.4),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40)
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
