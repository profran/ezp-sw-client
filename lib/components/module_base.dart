import 'package:flutter/material.dart';

class ModuleBase extends StatelessWidget {
  const ModuleBase(
      {Key key, this.delete, this.onPressed, this.color, @required this.child})
      : super(key: key);

  final Function delete;
  final Function onPressed;
  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        if (this.delete != null) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0))),
                title: Text('Delete module'),
                content: Text('Are you sure you want to delete it?'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Delete'),
                    onPressed: () {
                      this.delete();
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
        }
      },
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: BorderSide(color: Colors.grey[400], width: 1.0),
        ),
        elevation: 0.0,
        color: this.color ?? Theme.of(context).dialogBackgroundColor,
        onPressed: () {
          this.onPressed();
        },
        child: this.child,
      ),
    );
  }
}
