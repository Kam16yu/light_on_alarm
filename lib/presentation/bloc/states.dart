import 'package:blackout_light_on/domain/entities/settings_model.dart';

abstract class ListState {}

class ListInitState extends ListState {}

class HomePageState implements ListState {
  final List data;

  HomePageState(this.data);
}

class AlertUiState implements ListState {
  final String data;

  AlertUiState(this.data);
}

class GetWiFiState implements ListState {
  final List<List<String>> wifi;

  GetWiFiState(this.wifi);
}

class GetSettingsState implements ListState {
  final Settings settings;

  GetSettingsState(this.settings);
}

class GetSavedWiFiState implements ListState {
  final List<List<String>> wifi;

  GetSavedWiFiState(this.wifi);
}