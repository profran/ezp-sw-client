import 'package:flutter/material.dart';
import '../models/module.dart';
import '../state/mqtt.dart';

class LightSwitch extends StatelessWidget {
  const LightSwitch({Key key, this.module}) : super(key: key);

  final Module module;

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
        color: module.state == '1'
            ? Theme.of(context).primaryColor
            : Theme.of(context).dialogBackgroundColor,
        onPressed: () {
          // MqttState.of(context).switchHandler(light.topic, !light.state);
        },
        child: Text(
          module.alias,
          style: module.state == '1' ? Theme.of(context).primaryTextTheme.button : null,
        ),
      ),
    );
  }
}
