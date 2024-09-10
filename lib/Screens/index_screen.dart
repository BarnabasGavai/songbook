import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:songbookapp/logic/firestore_service.dart';
import 'package:songbookapp/logic/hive_service_provider.dart';
import 'package:songbookapp/logic/model_theme.dart';

class Indexscreen extends StatelessWidget {
  Indexscreen({super.key});
  final List<String> hindiAlphabets = [
    // Vowels (Swar)
    "अ", "आ", "इ", "ई", "उ", "ऊ", "ऋ", "ए", "ऐ", "ओ", "औ",

    // Consonants (Vyanjan)
    "क", "ख", "ग", "घ", "ङ",
    "च", "छ", "ज", "झ", "ञ",
    "ट", "ठ", "ड", "ढ", "ण",
    "त", "थ", "द", "ध", "न",
    "प", "फ", "ब", "भ", "म",
    "य", "र", "ल", "व",
    "श", "ष", "स", "ह",

    // Compound letters
    "क्ष", "त्र", "ज्ञ",
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer3<ModelTheme, FirestoreService, HiveService>(
        builder: (context, themeNotifier, dataNotifier, localNotifier, child) {
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
        body: Container(
          padding: const EdgeInsets.fromLTRB(17, 10, 17, 10),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 100),
            itemCount: hindiAlphabets.length,
            itemBuilder: (context, index) => InkWell(
              onTap: () => Navigator.pushNamed(context, '/letterlist',
                  arguments: {"myLetter": hindiAlphabets[index]}),
              child: Container(
                margin: const EdgeInsets.all(6),
                height: 50,
                color: (themeNotifier.isDark)
                    ? const Color(0xAA2C3335)
                    : const Color(0xAADAE0E2),
                child: Center(
                  child: Text(
                    "${hindiAlphabets[index]}",
                    style: const TextStyle(
                        fontSize: 25, fontWeight: FontWeight.w400),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
