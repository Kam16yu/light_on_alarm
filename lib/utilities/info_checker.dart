import 'dart:async';
import 'dart:io';

import 'package:battery_plus/battery_plus.dart';
import 'package:carrier_info/carrier_info.dart';
import 'package:flutter/foundation.dart';

//Checking internet connection
Future<bool> internetConnect({String address = 'example.com'}) async {
  bool isOnline = false;
  try {
    final result = await InternetAddress.lookup(address);
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
///Return type of mobile network 2G,3G,4G,5G
Future<String?>? getMobileNetworkStatus() async {
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
