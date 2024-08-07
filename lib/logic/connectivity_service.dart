import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectivityService extends ChangeNotifier {
  final Connectivity _connectivity = Connectivity();
  ConnectivityResult _connectionStatus = ConnectivityResult.none;

  ConnectivityService() {
    _initialize();
  }

  ConnectivityResult get connectionStatus => _connectionStatus;

  Future<void> _initialize() async {
    _connectionStatus = await _connectivity.checkConnectivity();
    _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      if (_connectionStatus != result) {
        _connectionStatus = result;
        notifyListeners();
      }
    });
  }

  Future<void> get initialization => _initialize();

  bool get isConnected => _connectionStatus != ConnectivityResult.none;
}
