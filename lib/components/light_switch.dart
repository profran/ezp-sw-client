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
        side: BorderSide(color: Colors.grey[400], width: 1.0),
      ),
      elevation: 0.0,
      color: state ? Theme.of(context).primaryColor : Colors.transparent,
      onPressed: () {
        switchHandler(topic, !state);
      },
      child: Text(
        alias,
        style: state ? Theme.of(context).primaryTextTheme.button : null,
      ),
    );
  }
}
