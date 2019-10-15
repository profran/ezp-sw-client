import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsContainer extends StatefulWidget {
  SettingsContainer({Key key, this.child}) : super(key: key);

  final Widget child;

  _SettingsContainerState createState() => _SettingsContainerState();
}

class _SettingsContainerState extends State<SettingsContainer> {
  String brokerURL = '10.0.2.2';
  int brokerPort = 1883;
  String brokerUsername;
  String brokerPassword;
  bool darkMode = false;

  void changeBrokerURL(String brokerURL) {
    _saveBrokerURL(brokerURL);
  }

  void _saveBrokerURL(String newBrokerURL) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('brokerURL', newBrokerURL);
    setState(() {
      brokerURL = newBrokerURL != '' ? newBrokerURL : null;
    });
  }

  void _getSavedBrokerURL() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      brokerURL = prefs.getString('brokerURL') != '' ? prefs.getString('brokerURL') : null;
    });
  }

  void changeBrokerPort(int brokerPort) {
    _saveBrokerPort(brokerPort);
  }

  void _saveBrokerPort(int newBrokerPort) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setInt('brokerPort', newBrokerPort);
    setState(() {
      brokerPort = newBrokerPort ?? 1883;
    });
  }

  void _getSavedBrokerPort() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      brokerPort = prefs.getInt('brokerPort') ?? 1883;
    });
  }

  void changeBrokerUsername(String brokerUsername) {
    _saveBrokerUsername(brokerUsername);
  }

  void _saveBrokerUsername(String newBrokerUsername) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('brokerUsername', newBrokerUsername);
    setState(() {
      brokerUsername = newBrokerUsername != '' ? newBrokerUsername : null;
    });
  }

  void _getSavedBrokerUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      brokerUsername = prefs.getString('brokerUsername') != '' ? prefs.getString('brokerUsername') : null;
    });
  }

  void changeBrokerPassword(String brokerPassword) {
    _saveBrokerPassword(brokerPassword);
  }

  void _saveBrokerPassword(String newBrokerPassword) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('brokerPassword', newBrokerPassword);
    setState(() {
      brokerPassword = newBrokerPassword != '' ? newBrokerPassword : null;
    });
  }

  void _getSavedBrokerPassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      brokerPassword = prefs.getString('brokerPassword') != '' ? prefs.getString('brokerPassword') : null;
    });
  }

  void changeDarkMode(bool newDarkMode) {
    _saveDarkMode(newDarkMode);
  }

  void _saveDarkMode(bool newDarkMode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setBool('darkMode', newDarkMode);
    setState(() {
      darkMode = newDarkMode;
    });
  }

  void _getSavedDarkMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      darkMode = prefs.getBool('darkMode') ?? false;
    });
  }

  @override
  void initState() {
    _getSavedBrokerURL();
    _getSavedBrokerPort();
    _getSavedBrokerUsername();
    _getSavedBrokerPassword();
    _getSavedDarkMode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Settings(
      brokerURL,
      changeBrokerURL,
      brokerPort,
      changeBrokerPort,
      brokerUsername,
      changeBrokerUsername,
      brokerPassword,
      changeBrokerPassword,
      darkMode,
      changeDarkMode,
      child: this.widget.child,
    );
  }
}

class Settings extends InheritedWidget {
  Settings(
      this.brokerURL,
      this.changeBrokerURL,
      this.brokerPort,
      this.changeBrokerPort,
      this.brokerUsername,
      this.changeBrokerUsername,
      this.brokerPassword,
      this.changeBrokerPassword,
      this.darkMode,
      this.changeDarkMode,
      {Key key,
      this.child})
      : super(key: key, child: child);

  final Widget child;
  final String brokerURL;
  final ValueChanged<String> changeBrokerURL;
  final int brokerPort;
  final ValueChanged<int> changeBrokerPort;
  final String brokerUsername;
  final ValueChanged<String> changeBrokerUsername;
  final String brokerPassword;
  final ValueChanged<String> changeBrokerPassword;
  final bool darkMode;
  final ValueChanged<bool> changeDarkMode;

  static Settings of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(Settings) as Settings);
  }

  @override
  bool updateShouldNotify(Settings oldWidget) {
    return true;
  }
}
