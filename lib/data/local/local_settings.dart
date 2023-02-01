import 'package:blackout_light_on/domain/entities/settings_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> saveLocalSettings(Settings obj) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isBlackout', obj.isBlackout);
  await prefs.setBool('grantedPermissions', obj.grantedPermissions);
  await prefs.setBool('alwaysAlert', obj.alwaysAlert);
  await prefs.setBool('useOffMobile3G4G5G', obj.useOffMobile3G4G5G);
  await prefs.setBool('useOffWiFi', obj.useOffWiFi);
  await prefs.setBool('useOffPing', obj.useOffPing);
  await prefs.setBool('useOffChargeState', obj.useOffChargeState);
  await prefs.setBool('useOnMobile3G4G5G', obj.useOnMobile3G4G5G);
  await prefs.setBool('useOnWiFi', obj.useOnWiFi);
  await prefs.setBool('useOnPing', obj.useOnPing);
  await prefs.setBool('useOnChargeState', obj.useOnChargeState);
  await prefs.setBool('runBackground', obj.runBackground);
  await prefs.setInt('checkTiming', obj.checkTiming);
  await prefs.setBool('manualOffOn', obj.manualOffOn);
  await prefs.setStringList('ipAddressesForPing', obj.ipAddressesForPing);
  await prefs.setBool('wakeUpScreenAlert', obj.wakeUpScreenAlert);
  return true;
}

///If not was saved Parameter First run true, another false
Future<Settings> getLocalSettings() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return Settings(
    isBlackout: prefs.getBool('isBlackout') ?? false,
    grantedPermissions: prefs.getBool('grantedPermissions') ?? false,
    alwaysAlert: prefs.getBool('alwaysAlert') ?? false,
    useOffMobile3G4G5G: prefs.getBool('useOffMobile3G4G5G') ?? false,
    useOffWiFi: prefs.getBool('useOffWiFi') ?? false,
    useOffPing: prefs.getBool('useOffPing') ?? false,
    useOffChargeState: prefs.getBool('useOffChargeState') ?? false,
    useOnMobile3G4G5G: prefs.getBool('useOnMobile3G4G5G') ?? false,
    useOnWiFi: prefs.getBool('useOnWiFi') ?? false,
    useOnPing: prefs.getBool('useOnPing') ?? false,
    useOnChargeState: prefs.getBool('useOnChargeState') ?? false,
    runBackground: prefs.getBool('runBackground') ?? false,
    checkTiming: prefs.getInt('checkTiming') ?? 15,
    manualOffOn: prefs.getBool('manualOffOn') ?? false,
    ipAddressesForPing: prefs.getStringList('ipAddressesForPing') ?? ['example.com'],
    wakeUpScreenAlert: prefs.getBool('wakeUpScreenAlert') ?? false,
  );
}
