import 'package:wifi_scan/wifi_scan.dart';

///false - Not get WiFi - not granted permissions, or not active Location
Future<bool> startScan() async {
  // check platform support and necessary requirements
  final can = await WiFiScan.instance.canStartScan();
  if (can == CanStartScan.yes) {
    final result = await WiFiScan.instance.startScan();
    if (result) {
      return true;
    }
  }
  return false;
}

///Return List<WiFiAccessPoint> or null if error
Future<List<WiFiAccessPoint>?> getScannedResults() async {
  // check platform support and necessary requirements
  final can = await WiFiScan.instance.canGetScannedResults();
  if (can == CanGetScannedResults.yes) {
    final accessPoints = await WiFiScan.instance.getScannedResults();
    return accessPoints;
  }
  return null;
}
