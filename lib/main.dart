import 'package:flutter/material.dart';
import 'package:mqtt_switch/components/add_light.dart';
import 'package:mqtt_switch/components/home.dart';
import 'package:mqtt_switch/components/settings.dart';
import 'package:mqtt_switch/state/lights.dart';
import 'package:mqtt_switch/state/settings.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  const App({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SettingsContainer(
      child: LightsContainer(
        child: Builder(builder: (context) {
          return MaterialApp(
            title: 'MQTT Switch',
            theme: Settings.of(context).darkMode ? darkMode : lightMode,
            darkTheme: darkMode,
            initialRoute: '/',
            routes: {
              '/': (context) => Home(),
              '/add': (context) => AddLight(),
              '/settings': (context) => SettingsScreen(),
            },
          );
        }),
      ),
    );
  }
}
