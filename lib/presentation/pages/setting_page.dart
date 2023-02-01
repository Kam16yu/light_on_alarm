import 'package:blackout_light_on/domain/entities/background_commands.dart';
import 'package:blackout_light_on/domain/entities/settings_model.dart';
import 'package:blackout_light_on/presentation/bloc/bloc.dart';
import 'package:blackout_light_on/presentation/bloc/events.dart';
import 'package:blackout_light_on/presentation/bloc/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final _formKey = GlobalKey<FormState>();
  Settings? settings;
  String ipAddress = '';

  @override
  void initState() {
    super.initState();
    BlocProvider.of<MainBloc>(context).add(GetSettingsEvent());
  }

  @override
  Widget build(BuildContext context) {
    final MainBloc mainBloc = BlocProvider.of<MainBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          IconButton(
            onPressed: () {
              if (settings != null) {
                ///Todo. add more ip support?
                if (ipAddress.isNotEmpty) {
                  settings?.ipAddressesForPing = [ipAddress];
                }
                mainBloc.add(SaveSettingsEvent(settings!));
              }
            },
            icon: const Icon(Icons.save),
          )
        ],
      ),
      body: BlocConsumer<MainBloc, ListState>(
        listener: (context, state) {
          if (state is GetSettingsState) {
            settings = state.settings;
          }
          if (state is AlertUiState) {
            final String info = state.data;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: const Duration(seconds: 1),
                content: Text(info),
                dismissDirection: DismissDirection.horizontal,
              ),
            );
          }
        },
        builder: (context, state) {
          if (settings == null) {
            return const Center(child: Icon(Icons.recycling));
          } else {
            return ListView(
              children: [
                Row(
                  children: [
                    const Text(
                      'Grant permissions',
                      style: TextStyle(fontSize: 17.0),
                    ),
                    Checkbox(
                      value: settings?.grantedPermissions ?? false,
                      onChanged: (value) {
                        setState(() {
                          settings?.grantedPermissions = value!;
                        });
                      },
                    ),
                  ],
                ),
                const Text(
                  'Background check control',
                  style: TextStyle(fontSize: 20.0),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.not_started_outlined),
                      onPressed: () {
                        settings?.runBackground = true;
                        mainBloc.add(
                          BackgroundProcessEvent(
                            BackgroundCommands.start,
                            settings?.checkTiming ?? 15,
                          ),
                        );
                        if (settings != null) {
                          mainBloc.add(SaveSettingsEvent(settings!));
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.restart_alt),
                      onPressed: () {
                        settings?.runBackground = true;
                        mainBloc.add(
                          BackgroundProcessEvent(
                            BackgroundCommands.restart,
                            settings?.checkTiming ?? 15,
                          ),
                        );
                        if (settings != null) {
                          mainBloc.add(SaveSettingsEvent(settings!));
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.stop),
                      onPressed: () {
                        settings?.runBackground = false;
                        mainBloc.add(
                          BackgroundProcessEvent(
                            BackgroundCommands.stop,
                            settings?.checkTiming ?? 15,
                          ),
                        );
                        if (settings != null) {
                          mainBloc.add(SaveSettingsEvent(settings!));
                        }
                      },
                    ),
                  ],
                ),
                const Divider(thickness: 2.0),
                const Text(
                  'Methods of detecting blackouts, when need alert',
                  style: TextStyle(fontSize: 20.0),
                ),
                Row(
                  children: [
                    const Text(
                      'Always alerts is on',
                      style: TextStyle(fontSize: 17.0),
                    ),
                    Checkbox(
                      value: settings?.alwaysAlert ?? false,
                      onChanged: (value) {
                        setState(() {
                          settings?.alwaysAlert = value!;
                        });
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      'Mobile network type is 2G',
                      style: TextStyle(fontSize: 17.0),
                    ),
                    Checkbox(
                      value: settings?.useOffMobile3G4G5G ?? false,
                      onChanged: (value) {
                        setState(() {
                          settings?.useOffMobile3G4G5G = value!;
                        });
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      'Saved WiFi is off',
                      style: TextStyle(fontSize: 17.0),
                    ),
                    Checkbox(
                      value: settings?.useOffWiFi ?? false,
                      onChanged: (value) {
                        setState(() {
                          settings?.useOffWiFi = value!;
                        });
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      'Ping internet address',
                      style: TextStyle(fontSize: 17.0),
                    ),
                    Checkbox(
                      value: settings?.useOffPing ?? false,
                      onChanged: (value) {
                        setState(() {
                          settings?.useOffPing = value!;
                        });
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      'Device not charging',
                      style: TextStyle(fontSize: 17.0),
                    ),
                    Checkbox(
                      value: settings?.useOffChargeState ?? false,
                      onChanged: (value) {
                        setState(() {
                          settings?.useOffChargeState = value!;
                        });
                      },
                    ),
                  ],
                ),
                const Divider(thickness: 2.0),
                const Text(
                  'Methods of detecting light on',
                  style: TextStyle(fontSize: 20.0),
                ),
                Row(
                  children: [
                    const Text(
                      'Mobile network is improved',
                      style: TextStyle(fontSize: 17.0),
                    ),
                    Checkbox(
                      value: settings?.useOnMobile3G4G5G ?? false,
                      onChanged: (value) {
                        setState(() {
                          settings?.useOnMobile3G4G5G = value!;
                        });
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      'Saved WiFi is on',
                      style: TextStyle(fontSize: 17.0),
                    ),
                    Checkbox(
                      value: settings?.useOnWiFi ?? false,
                      onChanged: (value) {
                        setState(() {
                          settings?.useOnWiFi = value!;
                        });
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      'Ping internet address',
                      style: TextStyle(fontSize: 17.0),
                    ),
                    Checkbox(
                      value: settings?.useOnPing ?? false,
                      onChanged: (value) {
                        setState(() {
                          settings?.useOnPing = value!;
                        });
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      'Device is charging',
                      style: TextStyle(fontSize: 17.0),
                    ),
                    Checkbox(
                      value: settings?.useOnChargeState ?? false,
                      onChanged: (value) {
                        setState(() {
                          settings?.useOnChargeState = value!;
                        });
                      },
                    ),
                  ],
                ),
                const Divider(thickness: 2.0),
                Row(
                  children: [
                    const Text(
                      'Wake up screen with alert',
                      style: TextStyle(fontSize: 17.0),
                    ),
                    Checkbox(
                      value: settings?.wakeUpScreenAlert ?? false,
                      onChanged: (value) {
                        setState(() {
                          settings?.wakeUpScreenAlert = value!;
                        });
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Flexible(
                      child: Text(
                        'Enable manual control for blackout and light on modes',
                        style: TextStyle(fontSize: 17.0),
                      ),
                    ),
                    Checkbox(
                      value: settings?.manualOffOn ?? false,
                      onChanged: (value) {
                        setState(() {
                          settings?.manualOffOn = value!;
                        });
                      },
                    ),
                  ],
                ),
                const Text(
                  'Time between background checking:',
                  style: TextStyle(fontSize: 17.0),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  child: TextFormField(
                    maxLength: 3,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'minutes',
                    ),
                    onChanged: (value) {
                      setState(() {
                        settings?.checkTiming = int.tryParse(value) ?? 15;
                      });
                    },
                  ),
                ),
                const Text(
                  'Set ip address for ping:',
                  style: TextStyle(fontSize: 17.0),
                ),
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 5,
                    ),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter valid IP address ';
                        }
                        if (value.contains('.') == false) {
                          return 'Please enter valid IP address';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.url,
                      maxLines: null,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'IP address',
                      ),
                      onChanged: (value) {
                        final bool checkValid =
                            _formKey.currentState!.validate();
                        if (checkValid) {
                          setState(() {
                            ipAddress = value;
                          });
                        }
                      },
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
