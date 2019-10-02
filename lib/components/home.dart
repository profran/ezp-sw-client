import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart' as mqtt;
import 'package:mqtt_switch/components/light_switch.dart';
import 'package:mqtt_switch/components/shortcuts_widget.dart';
import 'package:mqtt_switch/state/lights.dart';
import 'package:mqtt_switch/state/settings.dart';

ThemeData lightMode = new ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.teal,
  primaryColor: Colors.teal,
  appBarTheme: AppBarTheme(
    color: Colors.teal,
    brightness: Brightness.light,
  ),
  scaffoldBackgroundColor: Colors.teal,
  backgroundColor: Colors.white,
);

ThemeData darkMode = new ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.teal,
  primaryColor: Colors.teal,
  appBarTheme: AppBarTheme(
    color: Colors.grey[800],
    brightness: Brightness.dark,
  ),
  scaffoldBackgroundColor: Colors.teal,
  backgroundColor: Colors.grey[900],
);

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  mqtt.MqttClient client;
  mqtt.MqttConnectionState connectionState;
  StreamSubscription subscription;
  var lightState = {};

  void _connect() async {
    print(Settings.of(context).brokerURL);
    client = mqtt.MqttClient(Settings.of(context).brokerURL, 'Flutter app');

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
    Lights.of(context).lights.forEach(
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
    Lights.of(context)
        .lights
        .forEach((light) => _publish(light.topic, message));
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
          tooltip: 'Add',
          onPressed: () {
            Navigator.pushNamed(context, '/add');
          },
          child: Icon(Icons.add),
        );
        break;
      case mqtt.MqttConnectionState.connecting:
        fab = FloatingActionButton(
          tooltip: 'Add',
          onPressed: null,
          child: CircularProgressIndicator(),
        );
        break;
      default:
        fab = FloatingActionButton.extended(
          tooltip: 'Connect',
          onPressed: _connect,
          label: Text('Connect to broker'),
        );
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: Icon(Icons.all_inclusive),
      ),
      backgroundColor: Theme.of(context).appBarTheme.color,
      floatingActionButton: fab,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
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
                  ListTile(
                    leading: Icon(Icons.close),
                    title: Text('Disconnect'),
                    onTap: () {
                      _disconnect();
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
          color: Theme.of(context).backgroundColor,
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
              indent: 18.0,
              endIndent: 18.0,
            ),
            Row(
              children: <Widget>[
                Expanded(
                    child: Lights.of(context).lights.isNotEmpty
                        ? GridView.count(
                            padding: EdgeInsets.all(18),
                            crossAxisSpacing: 18,
                            mainAxisSpacing: 18,
                            crossAxisCount: 2,
                            childAspectRatio: 2.0 / 1.0,
                            shrinkWrap: true,
                            children: Lights.of(context)
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
