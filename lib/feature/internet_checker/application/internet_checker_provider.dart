import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class InternetProvider extends ChangeNotifier {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription _subscription;
  bool _hasConnection = false;

  bool get hasConnection => _hasConnection;

  InternetProvider() {
    _checkInitial();
    _subscription = _connectivity.onConnectivityChanged.listen(_updateStatus);
  }

  Future<void> _checkInitial() async {
    final results = await _connectivity.checkConnectivity();
    _updateStatus(results);
  }

  void _updateStatus(List<ConnectivityResult> results) {
    final connected =
        results.isNotEmpty && !results.contains(ConnectivityResult.none);
    if (connected != _hasConnection) {
      _hasConnection = connected;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
