import 'package:blackout_light_on/domain/use_cases/operations.dart';
import 'package:workmanager/workmanager.dart';

const String workerName = 'simpleWorker';

@pragma(
  'vm:entry-point',
) // Mandatory if the App is obfuscated or using Flutter 3.1+
Future<void> callbackDispatcher() async {
  Workmanager().executeTask((task, inputData) async {
    if (task == workerName) {
      await checkAndAlert();
      return Future.value(true); // Task will be emitted here.
    }

    return Future.value(false);
  });
}

void startProcess({Duration workFrequency = const Duration(minutes: 15)}) {
  Workmanager().registerPeriodicTask(
    workerName,
    workerName,
    frequency: workFrequency,
    existingWorkPolicy: ExistingWorkPolicy.keep,
    backoffPolicy: BackoffPolicy.linear,
    backoffPolicyDelay: const Duration(seconds: 10),
    initialDelay: const Duration(seconds: 5),
  );
}

void restartProcess({Duration workFrequency = const Duration(minutes: 15)}) {
  Workmanager().registerPeriodicTask(
    workerName,
    workerName,
    frequency: workFrequency,
    existingWorkPolicy: ExistingWorkPolicy.replace,
    backoffPolicy: BackoffPolicy.linear,
    backoffPolicyDelay: const Duration(seconds: 10),
    initialDelay: const Duration(seconds: 5),
  );
}

void stopAll() {
  Workmanager().cancelAll();
}
