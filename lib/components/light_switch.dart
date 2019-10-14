import 'package:flutter/material.dart';
import 'package:mqtt_switch/models/light.dart';
import 'package:mqtt_switch/state/mqttState.dart';

class LightSwitch extends StatelessWidget {
  const LightSwitch({Key key, this.light}) : super(key: key);

  final Light light;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
              title: Text('Delete light'),
              content: Text('Are you sure you want to delete?'),
              actions: <Widget>[
                FlatButton(
                  child: Text('Delete'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                RaisedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Cancel',
                    style: Theme.of(context).primaryTextTheme.button,
                  ),
                ),
              ],
            );
          },
        );
      },
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: BorderSide(color: Colors.grey[400], width: 1.0),
        ),
        elevation: 0.0,
        color: light.state
            ? Theme.of(context).primaryColor
            : Theme.of(context).dialogBackgroundColor,
        onPressed: () {
          MqttState.of(context).switchHandler(light.topic, !light.state);
        },
        child: Text(
          light.alias,
          style: light.state ? Theme.of(context).primaryTextTheme.button : null,
        ),
      ),
    );
  }
}
