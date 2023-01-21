import 'dart:async';
import 'dart:io';

import 'package:battery_plus/battery_plus.dart';
import 'package:carrier_info/carrier_info.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool> askDevicePermissions() async {
  // Ask for permissions before requesting data
  final locationIfUse = await Permission.locationWhenInUse.request();
  final phone = await Permission.phone.request();
  if (locationIfUse == PermissionStatus.granted &&
      phone == PermissionStatus.granted) {
    final locationAlways = await Permission.locationAlways.request();
    if (locationAlways == PermissionStatus.granted) {
      return true;
    }
  }
  return false;
}

//Checking internet connection
Future<bool> internetConnect() async {
  bool isOnline = false;
  try {
    final result = await InternetAddress.lookup('example.com');
    isOnline = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
  } on SocketException catch (_) {
    isOnline = false;
  }

  return isOnline;
}

//Get info about battery Level
Future<int> chargeLevel() {
  return Battery().batteryLevel;
}

//Get info about power state - charging/discharging
Future<String> chargeState() async {
  final batteryState = await Battery().batteryState;
  return batteryState.toString();
}

Future<String?>? getCurrentNetworkStatus() async {
  // Platform messages may fail, so we use a try/catch PlatformException.
  try {
    if (Platform.isAndroid) {
      final info = await CarrierInfo.getAndroidInfo();
      return info?.telephonyInfo[0].networkGeneration;
    }
    if (Platform.isIOS) {
      final info = await CarrierInfo.getIosInfo();
      return info.carrierRadioAccessTechnologyTypeList[0];
    }
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }
  return 'denied';
}
