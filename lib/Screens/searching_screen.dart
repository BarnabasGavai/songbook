import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:songbookapp/logic/firestore_service.dart';
import 'package:songbookapp/logic/search_provider.dart';
import 'package:songbookapp/logic/autocomplete_service.dart';
import 'package:songbookapp/logic/connectivity_service.dart';
import 'package:songbookapp/logic/model_theme.dart';
import 'package:songbookapp/logic/wakelock_provider.dart';

class Searchingscreen extends StatelessWidget {
  const Searchingscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer4<ModelTheme, ConnectivityService, FirestoreService,
            AutoCOmpleteState>(
        builder: (context, themeNotifier, internetNotifier, dataNotifier,
            autocompleteNotifier, child) {
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
                  FocusManager.instance.primaryFocus?.unfocus();
                  Navigator.popAndPushNamed(context, "/downloads");
                },
                icon: const Icon(Icons.download_for_offline)),
            const SizedBox(
              width: 15,
            )
          ],
        ),
        body: Container(
          padding: const EdgeInsets.all(10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Autocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) async {
                if (textEditingValue.text.isEmpty) {
                  return dataNotifier.searchTitles("");
                }
                final suggestions =
                    await Provider.of<SearchProvider>(context, listen: false)
                        .getSuggestions(textEditingValue.text);
                return suggestions;
              },
              onSelected: (String selectedValue) {
                final selectedItem =
                    Provider.of<SearchProvider>(context, listen: false)
                        .firestoreService
                        .data
                        .firstWhere((item) => item['title'] == selectedValue);
                FocusManager.instance.primaryFocus?.unfocus();

                Provider.of<WakelockProvider>(context, listen: false)
                    .enableWakelock();

                Navigator.pushNamed(context, '/lyrics', arguments: {
                  "fromdownloads": false,
                  "mysong": selectedItem,
                  "youtube": (selectedItem['hasYoutube'])
                }).then(
                  (value) => Navigator.pop(context),
                );
              },
              fieldViewBuilder:
                  (context, controller, focusNode, onEditingComplete) {
                controller.addListener(() {
                  autocompleteNotifier.setText(controller.text);
                });
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  autofocus: true,
                  onEditingComplete: onEditingComplete,
                  decoration: InputDecoration(
                    suffixIcon: (autocompleteNotifier.text.isNotEmpty)
                        ? IconButton(
                            onPressed: () {
                              controller.clear();
                              autocompleteNotifier.clearText();
                              // Optionally, dismiss the autocomplete suggestions
                              FocusScope.of(context).unfocus();
                            },
                            icon: const Icon(Icons.clear),
                          )
                        : const Icon(Icons.search),
                    hintText: 'Search the song here',
                    border: const UnderlineInputBorder(
                        borderSide:
                            BorderSide(width: 1, style: BorderStyle.solid)),
                    filled: true,
                    fillColor: Colors.transparent,
                    focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                            width: 1,
                            style: BorderStyle.solid,
                            color: Colors.grey)),
                    enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                            width: 1,
                            style: BorderStyle.solid,
                            color: Colors.grey)),
                  ),
                );
              },
              optionsViewBuilder: (context, onSelected, options) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    margin: const EdgeInsets.only(right: 45),
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 0.7,
                            color: (themeNotifier.isDark)
                                ? const Color.fromARGB(255, 126, 126, 126)
                                : const Color.fromARGB(255, 195, 195, 195))),
                    child: ListView(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      children: options.map<Widget>((String option) {
                        return Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 0.2,
                                  color: const Color.fromARGB(
                                      255, 152, 152, 152))),
                          child: ListTile(
                            leading: const Icon(Icons.music_note),
                            title: Text(option),
                            onTap: () {
                              onSelected(option);
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );
    });
  }
}
