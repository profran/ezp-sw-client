import 'dart:async';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mqtt_client/mqtt_client.dart' as mqtt;
import 'package:mqtt_switch/components/add_light.dart';
import 'package:mqtt_switch/components/shortcuts_widget.dart';
import 'package:mqtt_switch/components/light_switch.dart';

void main() => runApp(MyApp());

const lights = [
  {
    'alias': 'Bedroom light',
    'topic': 'lights/1234',
  },
  {
    'alias': 'Heaven\'s door',
    'topic': 'lights/1235',
  },
  {
    'alias': 'Garden',
    'topic': 'lights/1236',
  },
  {
    'alias': 'Front door',
    'topic': 'lights/1237',
  },
];

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MQTT Switch',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColorDark: Colors.teal,
        appBarTheme: AppBarTheme(
          color: Colors.grey[800],
        )
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(title: 'Home'),
        '/add': (context) => AddLight()
      },
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
  mqtt.MqttClient client;
  mqtt.MqttConnectionState connectionState;
  StreamSubscription subscription;
  var lightState = {};

  void _connect() async {
    client = mqtt.MqttClient('192.168.0.253', 'Flutter app');

    client.logging(on: true);

    try {
      await client.connect();
    } catch (e) {
      print(e);
      _disconnect();
    }

    if (client.connectionState == mqtt.MqttConnectionState.connected) {
      print('MQTT client connected');
      setState(() {
        connectionState = client.connectionState;
      });
    } else {
      print('ERROR: MQTT client connection failed - '
          'disconnecting, state is ${client.connectionState}');
    }

    subscription = client.updates.listen(_onMessage);

    lights.forEach(
        (light) => client?.subscribe(light['topic'], mqtt.MqttQos.exactlyOnce));
  }

  void _disconnect() {
    client.disconnect();
    setState(() {
      connectionState = mqtt.MqttConnectionState.disconnected;
    });
  }

  void _onMessage(List<mqtt.MqttReceivedMessage> event) {
    print(event.length);
    final mqtt.MqttPublishMessage recMess =
        event[0].payload as mqtt.MqttPublishMessage;
    final String message =
        mqtt.MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

    print('MQTT message: topic is <${event[0].topic}>, '
        'payload is <-- $message -->');
    print(client.connectionState);

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
    client.publishMessage(topic, mqtt.MqttQos.values[0], builder.payload, retain: true);
  }

  void _broadcast(String message) {
    lights.forEach((el) => _publish(el['topic'], message));
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[800],
        centerTitle: true,
        title: Icon(Icons.all_inclusive),
      ),
      floatingActionButton: connected
          ? FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColorDark,
              tooltip: 'Add',
              onPressed: () {
                Navigator.pushNamed(context, '/add');
              },
              child: Icon(Icons.add),
            )
          : FloatingActionButton.extended(
              backgroundColor: Theme.of(context).primaryColorDark,
              tooltip: 'Add',
              onPressed: _connect,
              label: Text('Connect to broker'),
            ),
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
      backgroundColor: Colors.grey[900],
      body: ListView(
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
                child: GridView.count(
                  padding: EdgeInsets.all(18),
                  crossAxisSpacing: 18,
                  mainAxisSpacing: 18,
                  crossAxisCount: 2,
                  childAspectRatio: 2.0 / 1.0,
                  shrinkWrap: true,
                  children: lights
                      .map((light) => LightSwitch(
                            alias: light['alias'],
                            state: lightState[light['topic']] ?? false,
                            topic: light['topic'],
                            switchHandler: _switchHandler,
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
