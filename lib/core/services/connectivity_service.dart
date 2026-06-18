import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity connectivity;

  ConnectivityService(this.connectivity);

  Stream<List<ConnectivityResult>> get onConnectivityChanged =>
      connectivity.onConnectivityChanged;

  Future<bool> isConnected() async {
    final result = await connectivity.checkConnectivity();

    return !result.contains(
      ConnectivityResult.none,
    );
  }
}