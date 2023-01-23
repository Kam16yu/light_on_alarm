import 'package:blackout_light_on/domain/entities/background_commands.dart';
import 'package:blackout_light_on/domain/entities/settings_model.dart';

abstract class ListEvent {}

class InitEvent extends ListEvent {
  InitEvent();
}

class GetWiFIEvent extends ListEvent {
  GetWiFIEvent();
}

class BackgroundProcessEvent extends ListEvent {
  BackgroundCommands command;

  BackgroundProcessEvent(this.command);
}

class GetSettingsEvent extends ListEvent {
  GetSettingsEvent();
}

class SaveSettingsEvent extends ListEvent {
  Settings settings;

  SaveSettingsEvent(this.settings);
}

class AskPermissionsEvent extends ListEvent {
  AskPermissionsEvent();
}

class GetSavedWiFiEvent extends ListEvent {
  GetSavedWiFiEvent();
}

class SaveWiFiEvent extends ListEvent {
  List wifiList;

  SaveWiFiEvent(this.wifiList);
}

class HomeUiUpdateEvent extends ListEvent {
  HomeUiUpdateEvent();
}
