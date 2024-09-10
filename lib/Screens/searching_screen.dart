import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:songbookapp/logic/firestore_service.dart';
import 'package:songbookapp/logic/search_provider.dart';
import 'package:songbookapp/logic/autocomplete_service.dart';
import 'package:songbookapp/logic/connectivity_service.dart';
import 'package:songbookapp/logic/model_theme.dart';

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
        //   body: Center(
        //     child: SingleChildScrollView(
        //       child: Column(
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         children: <Widget>[
        //           const Text(
        //             "Praise the Lord!",
        //             textAlign: TextAlign.center,
        //             style:
        //                 TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        //           ),
        //           const SizedBox(
        //             height: 30,
        //           ),
        //           Container(
        //             padding: const EdgeInsets.symmetric(horizontal: 25),
        //             child: const Text(
        //               "Make a joyful noise unto the Lord, all ye lands. Serve the Lord with gladness: come before his presence with singing.\n Psalm 100: 1-2",
        //               textAlign: TextAlign.center,
        //               style: TextStyle(fontSize: 15),
        //             ),
        //           ),
        //           const SizedBox(
        //             height: 40,
        //           ),
        //           Container(
        //             width: MediaQuery.of(context).size.width * 0.6,
        //             padding: const EdgeInsets.symmetric(horizontal: 15),
        //             child: Autocomplete<String>(
        //               optionsBuilder:
        //                   (TextEditingValue textEditingValue) async {
        //                 if (textEditingValue.text.isEmpty) {
        //                   return const Iterable<String>.empty();
        //                 }
        //                 final suggestions = await Provider.of<SearchProvider>(
        //                         context,
        //                         listen: false)
        //                     .getSuggestions(textEditingValue.text);
        //                 return suggestions;
        //               },
        //               onSelected: (String selectedValue) {
        //                 final selectedItem = Provider.of<SearchProvider>(
        //                         context,
        //                         listen: false)
        //                     .firestoreService
        //                     .data
        //                     .firstWhere(
        //                         (item) => item['title'] == selectedValue);
        //                 FocusManager.instance.primaryFocus?.unfocus();

        //                 Navigator.pushNamed(context, '/lyrics', arguments: {
        //                   "fromdownloads": false,
        //                   "mysong": selectedItem,
        //                   "youtube": (selectedItem['hasYoutube'])
        //                 });
        //               },
        //               fieldViewBuilder: (context, controller, focusNode,
        //                   onEditingComplete) {
        //                 controller.addListener(() {
        //                   AutocompleteNotifier.setText(controller.text);
        //                 });
        //                 return TextField(
        //                   controller: controller,
        //                   focusNode: focusNode,
        //                   onEditingComplete: onEditingComplete,
        //                   decoration: InputDecoration(
        //                     suffixIcon: (AutocompleteNotifier.text.isNotEmpty)
        //                         ? IconButton(
        //                             onPressed: () {
        //                               controller.clear();
        //                               AutocompleteNotifier.clearText();
        //                               // Optionally, dismiss the autocomplete suggestions
        //                               FocusScope.of(context).unfocus();
        //                             },
        //                             icon: const Icon(Icons.clear),
        //                           )
        //                         : const Icon(Icons.search),
        //                     hintText: 'Search the song here',
        //                     border: const OutlineInputBorder(
        //                         borderRadius:
        //                             BorderRadius.all(Radius.circular(25))),
        //                     filled: true,
        //                     fillColor: Colors.transparent,
        //                     focusedBorder: const OutlineInputBorder(
        //                         borderSide: BorderSide(color: Colors.grey),
        //                         borderRadius:
        //                             BorderRadius.all(Radius.circular(25))),
        //                     enabledBorder: const OutlineInputBorder(
        //                         borderSide: BorderSide(color: Colors.grey),
        //                         borderRadius:
        //                             BorderRadius.all(Radius.circular(25))),
        //                   ),
        //                 );
        //               },
        //               optionsViewBuilder: (context, onSelected, options) {
        //                 return Align(
        //                   alignment: Alignment.topLeft,
        //                   child: Material(
        //                     elevation: 4.0,
        //                     child: Container(
        //                       width: MediaQuery.of(context).size.width * 0.6,
        //                       height: 200,
        //                       child: ListView(
        //                         padding: EdgeInsets.zero,
        //                         shrinkWrap: true,
        //                         children:
        //                             options.map<Widget>((String option) {
        //                           return ListTile(
        //                             title: Text(option),
        //                             onTap: () {
        //                               onSelected(option);
        //                             },
        //                           );
        //                         }).toList(),
        //                       ),
        //                     ),
        //                   ),
        //                 );
        //               },
        //             ),
        //           ),
        //           const SizedBox(
        //             height: 50,
        //           ),
        //           Container(
        //             height: 40,
        //             width: MediaQuery.of(context).size.width * 0.5,
        //             margin: EdgeInsets.symmetric(horizontal: 30),
        //             decoration: BoxDecoration(
        //                 border: Border.all(
        //                     color: (themeNotifier.isDark)
        //                         ? Colors.white
        //                         : Colors.black),
        //                 borderRadius:
        //                     const BorderRadius.all(Radius.circular(15))),
        //             child: InkWell(
        //               onTap: () {
        //                 FocusManager.instance.primaryFocus?.unfocus();
        //                 Navigator.pushNamed(context, '/index');
        //               },
        //               child: const Center(
        //                 child: Text(
        //                   "Letter Index",
        //                   style: TextStyle(
        //                       fontWeight: FontWeight.bold, fontSize: 16.4),
        //                 ),
        //               ),
        //             ),
        //           ),
        //           SizedBox(
        //             height: 50,
        //           ),
        //           Container(
        //             height: 40,
        //             width: MediaQuery.of(context).size.width * 0.5,
        //             margin: const EdgeInsets.symmetric(horizontal: 30),
        //             decoration: BoxDecoration(
        //                 border: Border.all(
        //                     color: (themeNotifier.isDark)
        //                         ? Colors.white
        //                         : Colors.black),
        //                 borderRadius:
        //                     const BorderRadius.all(Radius.circular(15))),
        //             child: InkWell(
        //               onTap: () {
        //                 FocusManager.instance.primaryFocus?.unfocus();
        //                 Navigator.pushNamed(context, '/list');
        //               },
        //               child: const Center(
        //                 child: Text(
        //                   "All Songs",
        //                   style: TextStyle(
        //                       fontWeight: FontWeight.bold, fontSize: 16.4),
        //                 ),
        //               ),
        //             ),
        //           ),
        //           SizedBox(height: 50)
        //         ],
        //       ),
        //     ),
        //   ),
        // );
      );
    });
  }
}
