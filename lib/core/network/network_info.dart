import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkInfo {
  Future<bool> get isConnected async {
    ConnectivityResult result = await Connectivity().checkConnectivity();

    return result == ConnectivityResult.wifi ||
        result == ConnectivityResult.mobile;
  }
}
