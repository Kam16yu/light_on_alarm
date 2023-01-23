import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool> askDevicePermissions() async {
  // Ask for permissions before requesting data
  final locationIfUse = await Permission.locationWhenInUse.request();
  final phone = await Permission.phone.request();
  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      // This is just a basic example. For real apps, you must show some
      // friendly dialog box before call the request method.
      // This is very important to not harm the user experience
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });
  if (locationIfUse == PermissionStatus.granted &&
      phone == PermissionStatus.granted) {
    final locationAlways = await Permission.locationAlways.request();
    if (locationAlways == PermissionStatus.granted) {
      return true;
    }
  }
  return false;
}
