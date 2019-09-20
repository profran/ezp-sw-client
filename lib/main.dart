import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MQTT Switch',
      theme: ThemeData(
          brightness: Brightness.dark, primaryColorDark: Colors.purple[200]),
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
        centerTitle: true,
        title: Icon(Icons.all_inclusive),
      ),
      body: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(18),
        crossAxisSpacing: 18,
        mainAxisSpacing: 18,
        crossAxisCount: 2,
        children: <Widget>[
          Container(
            child: RaisedButton(
              color: Theme.of(context).primaryColor,
              onPressed: () {},
            ),
          ),
          Container(
            child: RaisedButton(
              color: Theme.of(context).primaryColor,
              onPressed: () {},
            ),
          ),
        ],
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
