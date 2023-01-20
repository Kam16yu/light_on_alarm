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
    if (permissionsGranted == true){
      settings.grantedPermissions = true;
      await saveLocalSettings(settings);
    } else {
        return [settings, 'Not granted permissions'];
    }
  }
  final String mobileNetwork = await getCurrentNetworkStatus() ?? 'none';
  return [settings, 'Network: $mobileNetwork'];
}

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

Future<Settings> getSettings () async {

  return getLocalSettings();
}

Future<bool> saveSettings (Settings settings) async {

  return saveLocalSettings(settings);
}

void startBackground(){

  startProcess();
}

void restartBackground(){

  restartProcess();
}

void stopBackground(){

  stopAll();
}

Future<bool> askPermissions() async {

  return askDevicePermissions();
}

Future<List> getSavedWiFI () async {
  final List result = await getLocalWiFi();
  if (result[0] == true) {
    return result[1] as List<List<String>>;
  }

  return ['save empty', 'save empty'];
}

Future<bool> saveWiFi (List<List<String>> wifiList) async {

  return saveLocalWiFi(wifiList);
}