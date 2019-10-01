import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart' as mqtt;
import 'package:mqtt_switch/components/add_light.dart';
import 'package:mqtt_switch/components/light_switch.dart';
import 'package:mqtt_switch/components/settings.dart';
import 'package:mqtt_switch/components/shortcuts_widget.dart';
import 'package:mqtt_switch/models/light.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Light> lights = <Light>[];

  void addLight(String alias, String topic) async {
    Light light = Light(alias: alias, topic: topic);
    setState(() {
      lights.add(light);
    });
    _saveLights();
  }

  void _saveLights() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> lightList = [];
    print(lights);
    lights.forEach((light) => lightList.add(json.encode(light.toJson())));
    print(lightList);
    await prefs.setStringList('lights', lightList);
  }

  void _getSavedLights() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedLights = prefs.getStringList('lights');
    print(savedLights.toString());

    lights = [];
    savedLights?.forEach((light) => setState(() {
          lights.add(Light.fromJson(json.decode(light)));
        }));
  }

  @override
  void initState() {
    _getSavedLights();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MQTT Switch',
      theme: ThemeData(
          brightness: Brightness.dark,
          primaryColorDark: Colors.teal,
          appBarTheme: AppBarTheme(
            color: Colors.grey[800],
          )),
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(
              title: 'Home',
              lights: lights,
            ),
        '/add': (context) => AddLight(
              addLight: addLight,
            ),
        '/settings': (context) => Settings(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.lights}) : super(key: key);

  final String title;
  final List<Light> lights;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  mqtt.MqttClient client;
  mqtt.MqttConnectionState connectionState;
  StreamSubscription subscription;
  var lightState = {};

  void _connect() async {
    client = mqtt.MqttClient('10.0.2.2', 'Flutter app');

    client.onDisconnected = _onDisconnected;
    client.onConnected = _onConnected;

    try {
      setState(() {
        client.connectionStatus.state = mqtt.MqttConnectionState.connecting;
      });
      await client.connect();
    } catch (e) {
      print(e);
      _disconnect();
    }

    if (client?.connectionStatus?.state == mqtt.MqttConnectionState.connected) {
    } else {
      print('ERROR: MQTT client connection failed - '
          'disconnecting, state is ${client?.connectionStatus?.state}');
    }
  }

  void _onConnected() {
    print('MQTT client connected');

    setState(() {
      connectionState = client.connectionStatus.state;
    });

    subscription = client.updates.listen(_onMessage);
    this.widget.lights.forEach(
        (light) => client.subscribe(light.topic, mqtt.MqttQos.exactlyOnce));
  }

  void _disconnect() {
    client.disconnect();
  }

  void _onDisconnected() {
    setState(() {
      connectionState = client.connectionStatus.state;
      client = null;
      subscription?.cancel();
      subscription = null;
    });
  }

  void _onMessage(List<mqtt.MqttReceivedMessage> event) {
    final mqtt.MqttPublishMessage recMess =
        event[0].payload as mqtt.MqttPublishMessage;
    final String message =
        mqtt.MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

    print('MQTT message: topic is <${event[0].topic}>, '
        'payload is <-- $message -->');

    setState(() {
      lightState[event[0].topic] = message == '1' ? true : false;
    });
  }

  void _switchHandler(String topic, bool state) {
    _publish(topic, state ? '1' : '0');
  }

  void _publish(String topic, String message) {
    final mqtt.MqttClientPayloadBuilder builder =
        mqtt.MqttClientPayloadBuilder();

    builder.addString(message);
    client.publishMessage(topic, mqtt.MqttQos.values[0], builder.payload,
        retain: true);
  }

  void _broadcast(String message) {
    this.widget.lights.forEach((light) => _publish(light.topic, message));
  }

  void allOff() {
    _broadcast('0');
  }

  void allOn() {
    _broadcast('1');
  }

  @override
  Widget build(BuildContext context) {
    bool connected = connectionState == mqtt.MqttConnectionState.connected;

    Widget fab;

    switch (client?.connectionStatus?.state) {
      case mqtt.MqttConnectionState.connected:
        fab = FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColorDark,
          tooltip: 'Add',
          onPressed: () {
            Navigator.pushNamed(context, '/add');
          },
          child: Icon(Icons.add),
        );
        break;
      case mqtt.MqttConnectionState.connecting:
        fab = FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColorDark,
          tooltip: 'Add',
          onPressed: null,
          child: CircularProgressIndicator(),
        );
        break;
      default:
        fab = FloatingActionButton.extended(
          backgroundColor: Theme.of(context).primaryColorDark,
          tooltip: 'Connect',
          onPressed: _connect,
          label: Text('Connect to broker'),
        );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[800],
        elevation: 0.0,
        centerTitle: true,
        title: Icon(Icons.all_inclusive),
      ),
      floatingActionButton: fab,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: connected ? CircularNotchedRectangle() : null,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(connected ? Icons.clear : Icons.settings),
              onPressed: connected ? _disconnect : () {},
            ),
          ],
        ),
      ),
      backgroundColor: Colors.grey[800],
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.grey[800],
              ),
              child: Center(
                child: Text('MQTT Switch'),
              ),
            ),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('Settings'),
                    onTap: () {
                      Navigator.pushNamed(context, '/settings');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 6.0),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0)),
        ),
        child: ListView(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: ShortcutsWidget(
                    allOn: allOn,
                    allOff: allOff,
                  ),
                ),
              ],
            ),
            Divider(
              color: Colors.white54,
              thickness: 1.0,
              indent: 18.0,
              endIndent: 18.0,
            ),
            Row(
              children: <Widget>[
                Expanded(
                    child: this.widget.lights.isNotEmpty
                        ? GridView.count(
                            padding: EdgeInsets.all(18),
                            crossAxisSpacing: 18,
                            mainAxisSpacing: 18,
                            crossAxisCount: 2,
                            childAspectRatio: 2.0 / 1.0,
                            shrinkWrap: true,
                            children: this
                                .widget
                                .lights
                                .map((light) => LightSwitch(
                                      alias: light.alias,
                                      state: lightState[light.topic] ?? false,
                                      topic: light.topic,
                                      switchHandler: _switchHandler,
                                    ))
                                .toList(),
                          )
                        : Center(
                            child: CircularProgressIndicator(),
                          )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
