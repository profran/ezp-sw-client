import 'package:flutter/material.dart';
import 'package:mqtt_switch/models/light.dart';

class LightSwitch extends StatelessWidget {
  const LightSwitch({Key key, this.light, this.state, this.switchHandler})
      : super(key: key);

  final bool state;
  final Light light;
  final Function switchHandler;

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
        color: state
            ? Theme.of(context).primaryColor
            : Theme.of(context).dialogBackgroundColor,
        onPressed: () {
          switchHandler(light.topic, !state);
        },
        child: Text(
          light.alias,
          style: state ? Theme.of(context).primaryTextTheme.button : null,
        ),
      ),
    );
  }
}
