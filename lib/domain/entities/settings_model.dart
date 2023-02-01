class Settings {
  bool isBlackout;
  bool grantedPermissions;
  bool alwaysAlert;
  bool useOffMobile3G4G5G;
  bool useOffWiFi;
  bool useOffPing;
  bool useOffChargeState;
  bool useOnMobile3G4G5G;
  bool useOnWiFi;
  bool useOnPing;
  bool useOnChargeState;
  bool runBackground;

  ///timing between checks in background, minutes, minimum 15, best is 30 - for 1 minimum
  ///checking of WiFi, in active UI always is 1 minute
  int checkTiming;

  ///For widget, or UI manual switcher
  bool manualOffOn;
  List<String> ipAddressesForPing;
  bool wakeUpScreenAlert;

  Settings({
    this.isBlackout = false,
    this.grantedPermissions = false,
    this.alwaysAlert = false,
    this.useOffMobile3G4G5G = false,
    this.useOffWiFi = false,
    this.useOffPing = false,
    this.useOffChargeState = false,
    this.useOnMobile3G4G5G = false,
    this.useOnWiFi = false,
    this.useOnPing = false,
    this.useOnChargeState = false,
    this.runBackground = false,
    this.checkTiming = 15,
    this.manualOffOn = false,
    this.ipAddressesForPing = const [],
    this.wakeUpScreenAlert = false,
  });
}
