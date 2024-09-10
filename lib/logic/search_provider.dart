import 'dart:async';
import 'package:flutter/material.dart';
import 'firestore_service.dart';

class SearchProvider with ChangeNotifier {
  final FirestoreService _firestoreService;
  Timer? _debounce;

  SearchProvider(this._firestoreService);

  FirestoreService get firestoreService => _firestoreService;

  Future<List<String>> getSuggestions(String query) async {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {});

    // Simulate a delay for data fetching
    await Future.delayed(const Duration(milliseconds: 100));

    return _firestoreService.data
        .where((item) =>
            item['maintitle'].toLowerCase().contains(query.toLowerCase()) ||
            item['title'].toLowerCase().contains(query.toLowerCase()))
        .map((item) => item['title'] as String)
        .toList();
  }
}
