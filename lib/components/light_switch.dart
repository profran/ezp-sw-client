import 'package:flutter/material.dart';

class LightSwitch extends StatelessWidget {
  const LightSwitch(
      {Key key, this.alias, this.topic, this.state, this.switchHandler})
      : super(key: key);

  final String alias;
  final String topic;
  final bool state;
  final Function switchHandler;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: BorderSide(color: Colors.white54, width: 1.0)),
      color: state ? Theme.of(context).primaryColorDark : Colors.grey[800],
      onPressed: () {
        switchHandler(topic, !state);
      },
      child: Text(alias),
    );
  }
}
