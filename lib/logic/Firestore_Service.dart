import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestoreService extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  late Stream<List<Map<String, dynamic>>> _dataStream;
  List<Map<String, dynamic>> _data = [];
  Map<String, List<dynamic>> groupedItems = {};

  FirestoreService() {
    _dataStream = _db
        .collection('hindi')
        .orderBy('title', descending: false)
        .snapshots()
        .map(
      (snapshot) {
        return snapshot.docs.map((doc) {
          final myresdata = doc.data();
          Map<String, dynamic> myMap = {
            'maintitle': myresdata["maintitle"],
            'title': myresdata["title"],
            "song": "${myresdata["song"]}".replaceAll(r'\n', """

"""),
            "hasYoutube": myresdata.containsKey('youtube'),
            "youtube": (myresdata.containsKey('youtube'))
                ? "${myresdata['youtube']}"
                : ""
          };
          return myMap;
        }).toList();
      },
    );

    _dataStream.listen((data) {
      for (var i = 0; i < data.length; i++) {
        String firstletter = data[i]['title'][0];
        if (!groupedItems.containsKey(firstletter)) {
          groupedItems[firstletter] = [];
        }

        groupedItems[firstletter]?.add(data[i]);
      }
      _data = data;
      notifyListeners();
    });
  }

  List<Map<String, dynamic>> get data => _data;

  List<String> searchTitles(String query) {
    final results = _data
        .where((item) =>
            item['maintitle'].toLowerCase().contains(query.toLowerCase()))
        .map((item) => item['title'] as String)
        .toList();
    return results;
  }
}
