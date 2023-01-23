import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:blackout_light_on/domain/entities/background_commands.dart';
import 'package:blackout_light_on/domain/entities/settings_model.dart';
import 'package:blackout_light_on/domain/use_cases/operations.dart';
import 'package:blackout_light_on/presentation/bloc/events.dart';
import 'package:blackout_light_on/presentation/bloc/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainBloc extends Bloc<ListEvent, ListState> {
  MainBloc() : super(ListInitState()) {
    on<InitEvent>(initEvent);
    on<GetWiFIEvent>(getWiFIEvent);
    on<GetSettingsEvent>(getSettingsEvent);
    on<SaveSettingsEvent>(saveSettingsEvent);
    on<BackgroundProcessEvent>(backgroundControlEvent);
    on<AskPermissionsEvent>(askPermissionsEvent);
    on<GetSavedWiFiEvent>(getSavedWiFiEvent);
    on<SaveWiFiEvent>(saveWiFiEvent);
    on<HomeUiUpdateEvent>(homeUiUpdateEvent);
  }

  Future<void> initEvent(
    InitEvent event,
    Emitter<ListState> emitter,
  ) async {
    //Trigger cycle UI update
    while (true) {
      //Get program info and update UI
      final info = await getStatusInfo();
      emitter(HomePageState(info));
      final Settings settings = info[0] as Settings;
      //If granted permissions extend cycle timer and start checking
      if (settings.grantedPermissions == true) {
        await Future.delayed(const Duration(seconds: 30));

        if (settings.useOnWiFi == true) {
          final checkingWiFiResult = await checkWiFi();
          if (checkingWiFiResult == 0) {
            emitter(AlertUiState('not get saved WiFi'));
          }
          if (checkingWiFiResult == 1) {
            emitter(AlertUiState('error of scanning WiFi'));
          }
          if (checkingWiFiResult == 2) {
            AwesomeNotifications().createNotification(
              content: NotificationContent(
                id: 10,
                channelKey: 'basic_channel',
                title: 'Light on',
                body: 'Detected wifi',
                summary: 'Detected wifi',
                notificationLayout: NotificationLayout.Default,
                wakeUpScreen: true,
              ),
            );
          }
          if (checkingWiFiResult == 3) {
            emitter(AlertUiState('WiFi not found'));
          }
        }
      }
      //Timer
      await Future.delayed(const Duration(seconds: 30));
    }
  }

  Future<void> homeUiUpdateEvent(
    HomeUiUpdateEvent event,
    Emitter<ListState> emitter,
  ) async {
    final info = await getStatusInfo();
    emitter(HomePageState(info));
  }

  Future<void> getWiFIEvent(
    GetWiFIEvent event,
    Emitter<ListState> emitter,
  ) async {
    final result = await getWiFI();
    if (result[0] == true) {
      emitter(GetWiFiState(result[1] as List<List<String>>));
    } else {
      emitter(AlertUiState('Not get WiFi,WiFi and location is activated?'));
    }
  }

  Future<void> getSettingsEvent(
    GetSettingsEvent event,
    Emitter<ListState> emitter,
  ) async {
    final Settings settings = await getSettings();
    emitter(GetSettingsState(settings));
  }

  Future<void> saveSettingsEvent(
    SaveSettingsEvent event,
    Emitter<ListState> emitter,
  ) async {
    final bool result = await saveSettings(event.settings);
    if (result == true) {
      emitter(AlertUiState('saved'));
    } else {
      emitter(AlertUiState('not saved'));
    }
  }

  Future<void> backgroundControlEvent(
    BackgroundProcessEvent event,
    Emitter<ListState> emitter,
  ) async {
    if (event.command == BackgroundCommands.start) {
      startBackground();
    }
    if (event.command == BackgroundCommands.restart) {
      restartBackground();
    }
    if (event.command == BackgroundCommands.stop) {
      stopBackground();
    }
  }

  Future<void> askPermissionsEvent(
    AskPermissionsEvent event,
    Emitter<ListState> emitter,
  ) async {
    final bool result = await askPermissions();
    if (result == true) {
      final settings = await getSettings();
      settings.grantedPermissions = true;
      await saveSettings(settings);
      final info = await getStatusInfo();
      emitter(HomePageState(info));
    } else {
      emitter(AlertUiState('Not granted, please grant permissions'));
    }
  }

  Future<void> getSavedWiFiEvent(
    GetSavedWiFiEvent event,
    Emitter<ListState> emitter,
  ) async {
    final wifi = await getSavedWiFI();
    if (wifi[0] == true) {
      emitter(GetSavedWiFiState(wifi[1] as List<List<String>>));
    } else {
      emitter(AlertUiState('Not have saved WiFi'));
    }
  }

  //Rewrite saved WiFi if event.wifiList[1] is false or add new if true
  Future<void> saveWiFiEvent(
    SaveWiFiEvent event,
    Emitter<ListState> emitter,
  ) async {
    final result = await saveWiFi(
      event.wifiList[0] as List<List<String>>,
      addNew: event.wifiList[1] as bool,
    );
    if (result == true) {
      emitter(AlertUiState('Saved'));
    }
  }
}
