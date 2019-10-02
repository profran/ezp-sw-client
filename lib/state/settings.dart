import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsContainer extends StatefulWidget {
  SettingsContainer({Key key, this.child}) : super(key: key);

  final Widget child;

  _SettingsContainerState createState() => _SettingsContainerState();
}

class _SettingsContainerState extends State<SettingsContainer> {
  String brokerURL = 'brokerURL';
  bool darkMode = false;

  void changeBrokerURL(String brokerURL) {
    _saveBrokerURL(brokerURL);
  }

  void _saveBrokerURL(String newBrokerURL) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('brokerURL', newBrokerURL);
    setState(() {
      brokerURL = newBrokerURL;
    });
  }

  void _getSavedBrokerURL() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      brokerURL = prefs.getString('brokerURL');
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
      darkMode = prefs.getBool('darkMode');
    });
  }

  @override
  void initState() {
    _getSavedBrokerURL();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Settings(
      brokerURL,
      changeBrokerURL,
      darkMode,
      changeDarkMode,
      child: this.widget.child,
    );
  }
}

class Settings extends InheritedWidget {
  Settings(
      this.brokerURL, this.changeBrokerURL, this.darkMode, this.changeDarkMode,
      {Key key, this.child})
      : super(key: key, child: child);

  final Widget child;
  final String brokerURL;
  final ValueChanged<String> changeBrokerURL;
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
