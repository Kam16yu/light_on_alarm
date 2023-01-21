import 'dart:async';
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
  }

  Future<void> initEvent(
    InitEvent event,
    Emitter<ListState> emitter,
  ) async {
    final List info = await initModules();
    emitter(HomePageState(info));
    emitter(AlertUiState(info[1] as String));
    // //Trigger UI update if a background process updates Box
    while (true) {
      final Settings settings = await getSettings();
      if (settings.useOnWiFi == true) {
        final chekingResult = await checkWiFi();
        if (chekingResult[0] == 0) {
          emitter(AlertUiState(chekingResult[1] as String));
          }
        if (chekingResult[0] == 1) {
            emitter(AlertUiState('WiFi found'));
        }
        if (chekingResult[0] == 2) {
          emitter(AlertUiState('WiFi not found'));
        }
      }
      await Future.delayed(const Duration(minutes: 1));
    }
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
      final info = await initModules(permissionsGranted: true);
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
    final result = await saveWiFi(event.wifiList[0] as List<List<String>>,
        addNew: event.wifiList[1] as bool,);
    if (result == true) {
      emitter(AlertUiState('Saved'));
    }
  }
}
