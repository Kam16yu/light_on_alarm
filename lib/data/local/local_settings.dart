import 'package:blackout_light_on/domain/entities/settings_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> saveLocalSettings(Settings obj) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('firstRun', obj.firstRun);
  await prefs.setBool('grantedPermissions', obj.grantedPermissions);
  await prefs.setBool('useOffCarrier', obj.useOffCarrier);
  await prefs.setBool('useOffWiFi', obj.useOffWiFi);
  await prefs.setBool('useOnCarrier', obj.useOnCarrier);
  await prefs.setBool('useOnWiFi', obj.useOnWiFi);
  await prefs.setBool('runBackground', obj.runBackground);
  return true;
}

///If not was saved Parameter First run true, another false
Future<Settings> getLocalSettings() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return Settings(
    firstRun: prefs.getBool('firstRun') ?? true,
    grantedPermissions: prefs.getBool('grantedPermissions') ?? false,
    useOffCarrier: prefs.getBool('useOffCarrier') ?? false,
    useOffWiFi: prefs.getBool('useOffWiFi') ?? false,
    useOnCarrier: prefs.getBool('useOnCarrier') ?? false,
    useOnWiFi: prefs.getBool('useOnWiFi') ?? false,
    runBackground: prefs.getBool('runBackground') ?? false,
  );
}
