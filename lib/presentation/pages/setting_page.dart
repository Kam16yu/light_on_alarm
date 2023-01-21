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
  Settings? settings;

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
        title: const Text('Setting'),
        actions: [
          IconButton(
            onPressed: () {
              if (settings != null) {
                mainBloc.add(SaveSettingsEvent(settings!));
                mainBloc.add(InitEvent());
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
                duration: const Duration(seconds: 2),
                content: Text(info),
              ),
            );
          }
        },
        builder: (context, state) {
          if (settings == null) {
            return const Icon(Icons.recycling);
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                  'Detecting blackouts settings',
                  style: TextStyle(fontSize: 17.0),
                ),
                Row(
                  children: [
                    const Text(
                      'Use mobile network type',
                      style: TextStyle(fontSize: 17.0),
                    ),
                    Checkbox(
                      value: settings?.useOffCarrier ?? false,
                      onChanged: (value) {
                        setState(() {
                          settings?.useOffCarrier = value!;
                        });
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      'Use WiFi',
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
                const Text(
                  'Detecting light on settings',
                  style: TextStyle(fontSize: 17.0),
                ),
                Row(
                  children: [
                    const Text(
                      'Mobile network type',
                      style: TextStyle(fontSize: 17.0),
                    ),
                    Checkbox(
                      value: settings?.useOnCarrier ?? false,
                      onChanged: (value) {
                        setState(() {
                          settings?.useOnCarrier = value!;
                        });
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      'Use WiFi',
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
                const Text(
                  'Background process control',
                  style: TextStyle(fontSize: 17.0),
                ),
                Row(
                  children: [
                    ///Todo, back restarting all widgets?
                    IconButton(
                      icon: const Icon(Icons.not_started_outlined),
                      onPressed: () {
                        settings?.runBackground = true;
                        mainBloc.add(
                            BackgroundProcessEvent(BackgroundCommands.start),);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.restart_alt),
                      onPressed: () {
                        settings?.runBackground = true;
                        mainBloc.add(
                          BackgroundProcessEvent(BackgroundCommands.restart,),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.stop),
                      onPressed: () {
                        settings?.runBackground = false;
                        mainBloc.add(
                          BackgroundProcessEvent(BackgroundCommands.stop),
                        );
                      },
                    ),
                  ],
                )
              ],
            );
          }
        },
      ),
    );
  }
}
