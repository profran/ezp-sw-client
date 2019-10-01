import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsContainer extends StatefulWidget {
  SettingsContainer({Key key, this.child}) : super(key: key);

  final Widget child;

  _SettingsContainerState createState() => _SettingsContainerState();
}

class _SettingsContainerState extends State<SettingsContainer> {
  String brokerURL = 'brokerURL';

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
      child: this.widget.child,
    );
  }
}

class Settings extends InheritedWidget {
  Settings(this.brokerURL, this.changeBrokerURL, {Key key, this.child})
      : super(key: key, child: child);

  final Widget child;
  final String brokerURL;
  final ValueChanged<String> changeBrokerURL;

  static Settings of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(Settings) as Settings);
  }

  @override
  bool updateShouldNotify(Settings oldWidget) {
    return true;
  }
}
