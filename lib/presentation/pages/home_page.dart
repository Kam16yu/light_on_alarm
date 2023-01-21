import 'package:blackout_light_on/domain/entities/settings_model.dart';
import 'package:blackout_light_on/presentation/bloc/bloc.dart';
import 'package:blackout_light_on/presentation/bloc/events.dart';
import 'package:blackout_light_on/presentation/bloc/states.dart';
import 'package:blackout_light_on/presentation/pages/saved_wifi_page.dart';
import 'package:blackout_light_on/presentation/pages/setting_page.dart';
import 'package:blackout_light_on/presentation/pages/wifi_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? info;
  Settings? settings;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<MainBloc>(context).add(InitEvent());
  }

  @override
  Widget build(BuildContext context) {
    final MainBloc mainBloc = BlocProvider.of<MainBloc>(context);
    BlocProvider.of<MainBloc>(context).add(InitEvent());
    return Scaffold(
      appBar: AppBar(
        leading: PopupMenuButton(
          // add icon, by default "3 dot" icon
          // icon: Icon(Icons.book)
          itemBuilder: (context) {
            return [
              const PopupMenuItem<int>(
                value: 0,
                child: Text("Settings"),
              ),
              const PopupMenuItem<int>(
                value: 1,
                child: Text("WiFi search"),
              ),
              const PopupMenuItem<int>(
                value: 2,
                child: Text("Saved WiFi"),
              ),
            ];
          },
          onSelected: (value) {
            if (value == 0) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => BlocProvider.value(
                    value: mainBloc,
                    child: const SettingPage(),
                  ),
                ),
              );
            }
            if (value == 1) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => BlocProvider.value(
                    value: mainBloc,
                    child: const WiFiPage(),
                  ),
                ),
              );
            }
            if (value == 2) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => BlocProvider.value(
                    value: mainBloc,
                    child: const SavedWiFiPage(),
                  ),
                ),
              );
            }
          },
        ),
        title: const Text('Program State'),
      ),
      //Implementing Bloc in app
      body: Column(
        children: [
          BlocConsumer<MainBloc, ListState>(
            listener: (context, state) {
              if (state is AlertUiState) {
                final String alert = state.data;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: const Duration(seconds: 2),
                    content: Text(alert),
                  ),
                );
              }
              if (state is HomePageState) {
                settings = state.data[0] as Settings;
                info = state.data[1] as String;
              }
            },
            builder: (context, state) {
              if (settings == null) {
                return const Icon(Icons.recycling);
              }
              if (settings?.grantedPermissions == false) {
                return askPermissionsWidget();
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  const Text('Status:'),
                  Text('$info'),
                  Text('Background running ${settings?.runBackground}'),
                ],
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white38,
        elevation: 10,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                  padding: const EdgeInsets.fromLTRB(2.0, 2.0, 2.0, 2.0),
                  icon: const Icon(Icons.restart_alt_rounded),
                  iconSize: 40.0,
                  onPressed: () {
                    mainBloc.add(InitEvent());
                  },
                  tooltip: 'Update',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget askPermissionsWidget() {
    const textStyle = TextStyle(
      fontSize: 17,
    );
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
              style: textStyle,
              '   1) Please allow necessary permission for app and in open '
              'menu "Location permission"  choose "Allow all the time"'),
          const Text(
            style: textStyle,
            '   2) Need activate mobile Location for WiFI search',
          ),
          const Text(
              style: textStyle,
              '   3) If you use battery powersaver or background restriction, '
              'need set Light on full allowed'),
          TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                Colors.cyanAccent,
              ),
            ),
            onPressed: () {
              BlocProvider.of<MainBloc>(context).add(AskPermissionsEvent());
            },
            child: const Text(
              'Ask permissions',
              style: textStyle,
            ),
          ),
        ],
      ),
    );
  }
}
