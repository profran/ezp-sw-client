import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MQTT Switch',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColorDark: Colors.purple[200],
      ),
      home: MyHomePage(title: 'Home'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[700],
        centerTitle: true,
        title: Icon(Icons.all_inclusive),
      ),
      backgroundColor: Colors.grey[900],
      body: Container(
        child: GridView.count(
          primary: false,
          padding: EdgeInsets.all(18),
          crossAxisSpacing: 18,
          mainAxisSpacing: 18,
          crossAxisCount: 2,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white54, width: 1.0),
                  borderRadius: BorderRadius.circular(8.0)),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                color: Color(0xFF614A19),
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
                color: Color(0xFF5C2B29),
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
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColorDark,
        tooltip: 'Add',
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    );
  }
}
