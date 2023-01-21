import 'package:shared_preferences/shared_preferences.dart';

///Save List<List<String>> where it is List with WiFi ssid and bssid
Future<bool> saveLocalWiFi(List<List<String>> wifiList) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final List<String> allWiFi = [];
  for (final List<String> wifi in wifiList) {
    allWiFi.add(wifi[0]);
    allWiFi.add(wifi[1]);
  }
  await prefs.setStringList('wifiList', allWiFi);

  return true;
}

///return [false] if empty or [true, List<List<String>>] where it is List with WiFi ssid
///and bssid
Future<List> getLocalWiFi() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final List<String> allWiFi = prefs.getStringList('wifiList') ?? [];
  if (allWiFi.isNotEmpty) {
    final List<List<String>> wifiList = [];
    for (var i = 0; i < allWiFi.length; i += 2) {
      wifiList.add([allWiFi[i], allWiFi[i + 1]]);
    }

    return [true, wifiList];
  }

  return [false];
}
