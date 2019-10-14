import 'package:flutter/material.dart';
import 'package:mqtt_switch/components/add_light.dart';
import 'package:mqtt_switch/components/home.dart';
import 'package:mqtt_switch/components/settings.dart';
import 'package:mqtt_switch/state/lights.dart';
import 'package:mqtt_switch/state/mqttState.dart';
import 'package:mqtt_switch/state/settings.dart';

void main() => runApp(App());

ThemeData lightTheme = new ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.teal,
  primaryColor: Colors.teal,
  appBarTheme: AppBarTheme(
    color: Colors.teal,
    brightness: Brightness.light,
  ),
  scaffoldBackgroundColor: Colors.teal,
  backgroundColor: Colors.white,
);

ThemeData darkTheme = new ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.teal,
  primaryColor: Colors.teal,
  appBarTheme: AppBarTheme(
    color: Colors.grey[800],
    brightness: Brightness.dark,
  ),
  scaffoldBackgroundColor: Colors.teal,
  backgroundColor: Colors.grey[900],
);

class App extends StatelessWidget {
  const App({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SettingsContainer(
      child: LightsContainer(
        child: MqttStateContainer(
          child: Builder(builder: (context) {
            return MaterialApp(
              title: 'MQTT Switch',
              theme: Settings.of(context).darkMode ? darkTheme : lightTheme,
              darkTheme: darkTheme,
              initialRoute: '/',
              routes: {
                '/': (context) => Home(),
                '/add': (context) => AddLight(),
                '/settings': (context) => SettingsScreen(),
              },
            );
          }),
        ),
      ),
    );
  }
}
