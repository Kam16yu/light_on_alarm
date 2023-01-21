import 'package:wifi_scan/wifi_scan.dart';
///false - Not get WiFi - not granted permissions, or not active Location
Future<bool> startScan() async {
  // check platform support and necessary requirements
  final can = await WiFiScan.instance.canStartScan();
  print(can);
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

// // initialize accessPoints and subscription
// List<WiFiAccessPoint> accessPoints = [];
// StreamSubscription<List<WiFiAccessPoint>>? subscription;
//
// void _startListeningToScannedResults() async {
//   // check platform support and necessary requirements
//   final can = await WiFiScan.instance.canGetScannedResults();
//   switch(can) {
//     case CanGetScannedResults.yes:
//     // listen to onScannedResultsAvailable stream
//       subscription = WiFiScan.instance.onScannedResultsAvailable.listen((results) {
//         // update accessPoints
//         setState(() => accessPoints = results);
//       });
//       // ...
//       break;
//   // ... handle other cases of CanGetScannedResults values
//   }
// }
//
// // make sure to cancel subscription after you are done
// @override
// dispose() {
//   super.dispose();
//   subscription?.cancel();
// }
