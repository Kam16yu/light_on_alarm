import 'package:blackout_light_on/data/local/local_settings.dart';
import 'package:blackout_light_on/data/local/local_wifi.dart';
import 'package:blackout_light_on/domain/entities/settings_model.dart';
import 'package:blackout_light_on/utilities/info_checker.dart';
import 'package:blackout_light_on/utilities/notifications.dart';
import 'package:blackout_light_on/utilities/permissions.dart';
import 'package:blackout_light_on/utilities/wifi_get.dart';
import 'package:blackout_light_on/utilities/work_manager.dart';
import 'package:flutter/foundation.dart';

///Init module, return List with settings and string info,
Future<List> getStatusInfo() async {
  String textInfo = '';
  final settings = await getSettings();
  final String mobileNetwork = await getMobileNetworkStatus() ?? 'none';
  textInfo += 'Network: $mobileNetwork';

  return [settings, textInfo];
}

///Return true, List<List<String>> if search success, else return false
Future<List> getWiFI() async {
  final start = await startScan();
  if (start) {
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

void startBackground({Duration workFrequency = const Duration(minutes: 15)}) {
  startProcess(workFrequency: workFrequency);
}

void restartBackground({Duration workFrequency = const Duration(minutes: 15)}) {
  restartProcess(workFrequency: workFrequency);
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

Future<bool> checkIp(String address) async {
  return internetConnect(address: address);
}

Future<Settings> checkAndAlert({Settings? settings}) async {
  settings ??= await getSettings();
  if (settings.useOnChargeState || settings.useOffChargeState) {
    final powerState = await chargeState();

    if (powerState == 'BatteryState.charging') {
      if (settings.useOnChargeState &&
          (settings.isBlackout || settings.alwaysAlert)) {
        settings.isBlackout = false;
        await createAlert(
          alertText: 'Light is on: $powerState',
          wakeUpScreen: settings.wakeUpScreenAlert,
        );
      }
    } else if (settings.useOffChargeState) {
      await createAlert(
        alertText: 'Light is on: $powerState',
        wakeUpScreen: settings.wakeUpScreenAlert,
      );
      settings.isBlackout = true;
    }
  }

  //wifi check
  if (settings.useOnWiFi || settings.useOffWiFi) {
    final checkingWiFiResult = await checkWiFi();
    if (settings.useOnWiFi && (settings.isBlackout || settings.alwaysAlert)) {
      if (checkingWiFiResult == 0) {
        await createAlert(
          alertText: 'Alert: not is saved WiFi',
          wakeUpScreen: settings.wakeUpScreenAlert,
        );
      }
      //send if time between scans is great than 30 minutes - minimum time
      // for Android, else always will be error
      if (checkingWiFiResult == 1 && settings.checkTiming >= 30) {
        await createAlert(
          alertText: 'Alert: error of scanning WiFi',
          wakeUpScreen: settings.wakeUpScreenAlert,
        );
      }
      //change to light on mode
      if (checkingWiFiResult == 2) {
        settings.isBlackout = false;
        await createAlert(
          alertText: 'Light is on: Detected wifi',
          wakeUpScreen: settings.wakeUpScreenAlert,
        );
      }
    }
    //not find saved WiFi, change to blackout mode
    if (checkingWiFiResult == 3 && settings.useOffWiFi) {
      settings.isBlackout = true;
    }
  }
  //mobile network check
  if (settings.useOnMobile3G4G5G || settings.useOffMobile3G4G5G) {
    final String mobileNetwork = await getMobileNetworkStatus() ?? 'none';

    if (mobileNetwork != '2G' &&
        settings.useOnMobile3G4G5G &&
        (settings.isBlackout || settings.alwaysAlert)) {
      settings.isBlackout = false;
      await createAlert(
        alertText: 'Light is on: Detected improved mobile network',
        wakeUpScreen: settings.wakeUpScreenAlert,
      );
    }
    //detect 2G network and change to blackout mode
    if (mobileNetwork == '2G' && settings.useOffMobile3G4G5G) {
      settings.isBlackout = true;
    }
  }
  //check ip address
  if (settings.useOnPing || settings.useOffPing) {
    final bool ipCheck = await checkIp(settings.ipAddressesForPing[0]);
    if (ipCheck &&
        settings.useOnPing &&
        (settings.isBlackout || settings.alwaysAlert)) {
      settings.isBlackout = false;
      await createAlert(
        alertText: 'Light is on: Detected IP ${settings.ipAddressesForPing[0]}',
        wakeUpScreen: settings.wakeUpScreenAlert,
      );
    }
    if (ipCheck == false && settings.useOffPing) {
      settings.isBlackout = true;
    }
  }
  saveSettings(settings);

  return settings;
}
