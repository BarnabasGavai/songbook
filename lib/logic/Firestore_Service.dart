import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestoreService extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  late Stream<List<Map<String, dynamic>>> _dataStream;
  List<Map<String, dynamic>> _data = [];

  FirestoreService() {
    _dataStream = _db.collection('hindi').snapshots().map(
      (snapshot) {
        return snapshot.docs.map((doc) {
          final myresdata = doc.data();
          Map<String, dynamic> myMap = {
            'maintitle': myresdata["maintitle"],
            'title': myresdata["title"],
            "song": "${myresdata["song"]}".replaceAll(r'\n', """

""")
          };
          return myMap;
        }).toList();
      },
    );

    _dataStream.listen((data) {
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
