import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:blackout_light_on/main.dart';
import 'package:flutter/material.dart';

const String channelKey = 'basic_channel';

Future<void> initNotification() async {
  await AwesomeNotifications().initialize(
    // set the icon to null if you want to use the default app icon
    null,
    [
      NotificationChannel(
        channelGroupKey: 'basic_channel_group',
        channelKey: channelKey,
        channelName: 'Basic notifications',
        channelDescription: 'Basic notification channel',
        defaultColor: const Color(0xFF9D50DD),
        ledColor: Colors.white,
      )
    ],
    // Channel groups are only visual and are not required
    channelGroups: [
      NotificationChannelGroup(
        channelGroupKey: 'basic_channel_group',
        channelGroupName: 'Basic group',
      )
    ],
    debug: true,
  );
}

Future<bool> createAlert ({required String alertText, bool wakeUpScreen=false}) {
  return AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 10,
      channelKey: channelKey,
      title: 'Light on',
      body: alertText,
      summary: alertText,
      wakeUpScreen: true,
    ),
  );
}

/// Use this method to detect when a new notification or a schedule is created
@pragma("vm:entry-point")
Future<void> onNotificationCreatedMethod(
    ReceivedNotification receivedNotification) async {
  // Your code goes here
}

/// Use this method to detect every time that a new notification is displayed
@pragma("vm:entry-point")
Future<void> onNotificationDisplayedMethod(
    ReceivedNotification receivedNotification) async {
  // Your code goes here
}

/// Use this method to detect if the user dismissed a notification
@pragma("vm:entry-point")
Future<void> onDismissActionReceivedMethod(
    ReceivedAction receivedAction) async {
  // Your code goes here
}

/// Use this method to detect when the user taps on a notification or action button
@pragma("vm:entry-point")
Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
  // Your code goes here
  // Navigate into pages, avoiding to open the notification details page over another details page already opened
  MyApp.navigatorKey.currentState?.pushNamedAndRemoveUntil(
    '/notification-page',
    (route) => (route.settings.name != '/notification-page') || route.isFirst,
    arguments: receivedAction,
  );
}
