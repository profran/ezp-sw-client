import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ShortcutsWidget extends StatelessWidget {
  const ShortcutsWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: EdgeInsets.all(18),
      crossAxisSpacing: 18,
      mainAxisSpacing: 18,
      crossAxisCount: 2,
      childAspectRatio: 1.0 / 1.0,
      shrinkWrap: true,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white54, width: 1.0),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            color: Theme.of(context).primaryColorDark,
            onPressed: () {},
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  MdiIcons.lightbulbOnOutline,
                  size: 54.0,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    bottom: 16.0,
                  ),
                ),
                Text('Turn ON every light')
              ],
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.white54, width: 1.0),
              borderRadius: BorderRadius.circular(8.0)),
          child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            color: Colors.grey[800],
            onPressed: () {},
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  MdiIcons.lightbulbOffOutline,
                  size: 54.0,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    bottom: 16.0,
                  ),
                ),
                Text('Turn OFF every light')
              ],
            ),
          ),
        ),
      ],
    );
  }
}