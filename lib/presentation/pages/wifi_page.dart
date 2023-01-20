import 'package:blackout_light_on/presentation/bloc/bloc.dart';
import 'package:blackout_light_on/presentation/bloc/events.dart';
import 'package:blackout_light_on/presentation/bloc/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WiFiPage extends StatefulWidget {
  const WiFiPage({super.key});

  @override
  State<WiFiPage> createState() => _WiFiPageState();
}

class _WiFiPageState extends State<WiFiPage> {
  List<List<String>> wifiMap = [];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<MainBloc>(context).add(GetWiFIEvent());
  }

  @override
  Widget build(BuildContext context) {
    final MainBloc mainBloc = BlocProvider.of<MainBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search WiFi'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          BlocConsumer<MainBloc, ListState>(
            listener: (context, state) {
              if (state is GetWiFiListState) {
                wifiMap = state.wifi;
              }
              if (state is AlertUiState) {
                final String info = state.data;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(info),
                  ),
                );
              }
            },
            builder: (context, state) {
              return Expanded(
                child: ListView.builder(
                  itemCount: wifiMap.length,
                  itemBuilder: (context, index) {
                    final List wifi = wifiMap[index];
                    return InkWell(
                      splashColor: Colors.blue.withAlpha(30),
                      onTap: () {},
                      //CARD BODY
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text('Name: ${wifi[0]}'),
                                  Text(
                                    'SSID: ${wifi[1]}',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          BottomAppBar(
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
                        mainBloc.add(GetWiFIEvent());
                      },
                      tooltip: 'Update',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
