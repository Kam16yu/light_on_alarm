import 'package:blackout_light_on/data/local/local_settings.dart';
import 'package:blackout_light_on/data/local/local_wifi.dart';
import 'package:blackout_light_on/domain/entities/settings_model.dart';
import 'package:blackout_light_on/utilites/info_checker.dart';
import 'package:blackout_light_on/utilites/wifi_get.dart';
import 'package:blackout_light_on/utilites/work_manager.dart';

//Init module, mobile operator info
Future<List> initModules({bool permissionsGranted = false}) async {
  final settings = await getSettings();
  if (settings.grantedPermissions == false) {
    if (permissionsGranted == true) {
      settings.grantedPermissions = true;
      await saveLocalSettings(settings);
    } else {
      return [settings, 'Not granted permissions'];
    }
  }
  final String mobileNetwork = await getCurrentNetworkStatus() ?? 'none';

  return [settings, 'Network: $mobileNetwork'];
}
///Return [true, List] if search success, else [false]
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

Future<List> getSavedWiFI() async {
  final List result = await getLocalWiFi();
  return result;
}

///Get List<List<String>> and optional true if need add WiFi to saved WiFis
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

///return [0] and error, 1 - saved if WiFi is find, 2 - all completed,
///Not finding saved WiFi
Future<List> checkWiFi() async {
  final List result = await getLocalWiFi();
  if (result[0] == false) {
    return [0, 'Not saved WiFi'];
  }
  final resultOfScanning = await getWiFI();
  if (resultOfScanning [0] == false) {
    return [0, 'Error of scanning WiFi'];
  }
  final savedWiFi = result[1] as List<List<String>>;
  final scannedWiFi = resultOfScanning[1] as List<List<String>>;
  for (final newWiFi in scannedWiFi) {
    for (final oldWiFi in savedWiFi) {
      if (newWiFi[1] == oldWiFi[1]) {
        return [1, 'WiFi found'];
      }
    }
  }

  return [2, 'Not finding saved WiFi'];
}