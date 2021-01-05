import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'components/add_module.dart';
import 'components/home.dart';
import 'components/settings.dart';
import 'state/settings.dart';

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
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        return MaterialApp(
          title: 'EZP Client',
          theme: settings.darkMode ? darkTheme : lightTheme,
          darkTheme: darkTheme,
          initialRoute: '/',
          routes: {
            '/': (context) => Home(),
            '/add': (context) => AddModule(),
            '/settings': (context) => SettingsScreen(),
          },
        );
      },
    );
  }
}
