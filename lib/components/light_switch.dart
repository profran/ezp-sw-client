import 'package:flutter/material.dart';

class LightSwitch extends StatefulWidget {
  LightSwitch({Key key, this.alias, this.topic, this.state}) : super(key: key);

  final String alias;
  final String topic;
  final bool state;

  _LightSwitchState createState() => _LightSwitchState();
}

class _LightSwitchState extends State<LightSwitch> {
  bool _switchState = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(this.widget.alias),
      subtitle: Text('Status: ${this.widget.state ? 'ON' : 'OFF'}, 5min ago'),
      trailing: Switch(
        activeColor: Theme.of(context).primaryColorDark,
        value: this.widget.state,
        onChanged: (bool value) {
          setState(() {
            _switchState = !_switchState;
          });
        },
      ),
    );
  }
}
