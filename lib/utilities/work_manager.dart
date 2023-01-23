import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:blackout_light_on/domain/use_cases/operations.dart';
import 'package:workmanager/workmanager.dart';

const String workerName = 'simpleWorker';

@pragma(
  'vm:entry-point',
) // Mandatory if the App is obfuscated or using Flutter 3.1+
Future<void> callbackDispatcher() async {
  Workmanager().executeTask((task, inputData) async {
    if (task == workerName) {
      final checkingWiFiResult = await checkWiFi();
      if (checkingWiFiResult == 0) {
        AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: 10,
            channelKey: 'basic_channel',
            title: 'Light on',
            body: 'worker: not get saved WiFi',
            summary: 'worker: not get saved WiFi',
            actionType: ActionType.Default,
            wakeUpScreen: true,
          ),
        );
      }
      if (checkingWiFiResult == 1) {
        AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: 10,
            channelKey: 'basic_channel',
            title: 'Light on',
            body: 'worker: error of scanning WiFi',
            summary: 'worker: error of scanning WiFi',
            actionType: ActionType.Default,
            wakeUpScreen: true,
          ),
        );
      }
      if (checkingWiFiResult == 2) {
        AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: 10,
            channelKey: 'basic_channel',
            title: 'Light on',
            body: 'worker: Detected wifi',
            summary: 'worker: Detected wifi',
            actionType: ActionType.Default,
            wakeUpScreen: true,
          ),
        );
      }
      return Future.value(true); // Task will be emitted here.
    }

    return Future.value(false);
  });
}

void startProcess() {
  Workmanager().registerPeriodicTask(
    workerName,
    workerName,
    frequency: const Duration(minutes: 30),
    existingWorkPolicy: ExistingWorkPolicy.keep,
    backoffPolicy: BackoffPolicy.linear,
    backoffPolicyDelay: const Duration(seconds: 10),
    initialDelay: const Duration(seconds: 5),
  );
}

void restartProcess() {
  Workmanager().registerPeriodicTask(
    workerName,
    workerName,
    frequency: const Duration(minutes: 30),
    existingWorkPolicy: ExistingWorkPolicy.replace,
    backoffPolicy: BackoffPolicy.linear,
    backoffPolicyDelay: const Duration(seconds: 10),
    initialDelay: const Duration(seconds: 5),
  );
}

void stopAll() {
  Workmanager().cancelAll();
}
