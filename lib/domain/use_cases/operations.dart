import 'package:blackout_light_on/data/local/local_settings.dart';
import 'package:blackout_light_on/data/local/local_wifi.dart';
import 'package:blackout_light_on/domain/entities/settings_model.dart';
import 'package:blackout_light_on/utilities/info_checker.dart';
import 'package:blackout_light_on/utilities/permissions.dart';
import 'package:blackout_light_on/utilities/wifi_get.dart';
import 'package:blackout_light_on/utilities/work_manager.dart';
import 'package:workmanager/workmanager.dart';

///Init module, return List with settings and string info,
Future<List> getStatusInfo() async {
  String textInfo = '';
  final settings = await getSettings();
  if (settings.useOnCarrier == true || settings.useOffCarrier == true) {
    final String mobileNetwork = await getCurrentNetworkStatus() ?? 'none';
    textInfo += 'Network: $mobileNetwork';
  }

  return [settings, textInfo];
}

///Return true, List<List<String>> if search success, else return false
Future<List> getWiFI() async {
  final start = await startScan();
  if (start == true) {
    await Future.delayed(const Duration(seconds: 10));
    final wifi = await getScannedResults();
    if (wifi != null) {
      if (wifi.isNotEmpty) {
        final List<List<String>> wifiMap = [];
        for (final e in wifi) {
          wifiMap.add([e.ssid, e.bssid]);
        }

        return [true, wifiMap];
      }
    }
  }

  return [false];
}

Future<Settings> getSettings() async {
  return getLocalSettings();
}

Future<bool> saveSettings(Settings settings) async {
  return saveLocalSettings(settings);
}

void startBackground() {
  startProcess();
}

void restartBackground() {
  restartProcess();
}

void stopBackground() {
  stopAll();
}

Future<bool> askPermissions() async {
  return askDevicePermissions();
}

///return false if empty or true, List<List<String>> where it is List with WiFi
/// ssid and bssid
Future<List> getSavedWiFI() async {
  final List result = await getLocalWiFi();

  return result;
}

///Get List<List<String>> and optional true if need add WiFi to saved WiFi list
Future<bool> saveWiFi(
  List<List<String>> wifiList, {
  bool addNew = false,
}) async {
  if (addNew) {
    final List result = await getLocalWiFi();
    if (result[0] != false && wifiList.isNotEmpty) {
      final savedWiFi = result[1] as List<List<String>>;
      final List<List<String>> addWiFiList = [];
      for (final newWiFi in wifiList) {
        bool result = true;
        for (final oldWiFi in savedWiFi) {
          if (newWiFi[1] == oldWiFi[1]) {
            result = false;
            break;
          }
        }
        if (result) {
          addWiFiList.add(newWiFi);
        }
      }
      savedWiFi.addAll(addWiFiList);

      return saveLocalWiFi(savedWiFi);
    }
  }

  return saveLocalWiFi(wifiList);
}

///return 0 if not get saved WiFi, 1 - if error of scanning WiFi,
///2 - WiFi is find, 3 - completed, not finding saved WiFi
Future<int> checkWiFi() async {
  final List result = await getSavedWiFI();
  if (result[0] == false) {
    return 0;
  }
  final resultOfScanning = await getWiFI();
  if (resultOfScanning[0] == false) {
    return 1;
  }
  final savedWiFi = result[1] as List<List<String>>;
  final scannedWiFi = resultOfScanning[1] as List<List<String>>;
  for (final newWiFi in scannedWiFi) {
    for (final oldWiFi in savedWiFi) {
      if (newWiFi[1] == oldWiFi[1]) {
        return 2;
      }
    }
  }

  return 3;
}
