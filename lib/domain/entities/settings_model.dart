class Settings {
  bool firstRun = false;
  bool grantedPermissions = false;
  bool useOffCarrier = false;
  bool useOffWiFi = false;
  bool useOnCarrier = false;
  bool useOnWiFi = false;
  bool runBackground = false;

  Settings({
    required this.firstRun,
    required this.grantedPermissions,
    required this.useOffCarrier,
    required this.useOffWiFi,
    required this.useOnCarrier,
    required this.useOnWiFi,
    required this.runBackground,
  });
}
