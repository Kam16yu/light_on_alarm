import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';

const String workerName = 'simpleWorker';

@pragma(
  'vm:entry-point',
) // Mandatory if the App is obfuscated or using Flutter 3.1+
Future<void> callbackDispatcher() async {
  Workmanager().executeTask((task, inputData) async {
    if (task == workerName) {
      // Ensure that plugin services are initialized
      WidgetsFlutterBinding.ensureInitialized();
      //Check and save info


      return Future.value(true); // Task will be emitted here.
    }

    return Future.value(false);
  });
}

void startProcess (){
  Workmanager().registerPeriodicTask(
    workerName,
    workerName,
    frequency: const Duration(minutes: 15),
    existingWorkPolicy: ExistingWorkPolicy.keep,
    backoffPolicy: BackoffPolicy.linear,
    backoffPolicyDelay: const Duration(seconds: 10),
    initialDelay: const Duration(seconds: 5),
  );
}

void restartProcess (){
  Workmanager().registerPeriodicTask(
    workerName,
    workerName,
    frequency: const Duration(minutes: 15),
    existingWorkPolicy: ExistingWorkPolicy.replace,
    backoffPolicy: BackoffPolicy.linear,
    backoffPolicyDelay: const Duration(seconds: 10),
    initialDelay: const Duration(seconds: 5),
  );
}

void stopAll (){
  Workmanager().cancelAll();
}
