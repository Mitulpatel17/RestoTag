
import 'package:connectivity_plus/connectivity_plus.dart';

class Methods{
  Future<bool> isConnected() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }
}