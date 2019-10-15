import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_switch/models/light.dart';
import 'package:mqtt_switch/state/lights.dart';
import 'package:mqtt_switch/state/settings.dart';

class MqttStateContainer extends StatefulWidget {
  MqttStateContainer({Key key, this.child}) : super(key: key);

  final Widget child;

  _MqttStateContainerState createState() => _MqttStateContainerState();
}

class _MqttStateContainerState extends State<MqttStateContainer> {
  List<Light> lights = <Light>[];

  MqttClient client;
  MqttConnectionState connectionState;
  StreamSubscription subscription;

  void connect() async {
    print(Settings.of(context).brokerURL);
    client = MqttClient(Settings.of(context).brokerURL, 'Flutter app');

    if (Settings.of(context).brokerPort != null) {
      client.port = Settings.of(context).brokerPort;
    }
    client.logging(on: true);
    client.onDisconnected = _onDisconnected;
    client.onConnected = _onConnected;

    try {
      setState(() {
        client.connectionStatus.state = MqttConnectionState.connecting;
      });
      await client.connect(Settings.of(context).brokerUsername, Settings.of(context).brokerPassword);
    } catch (e) {
      print(e);
      disconnect();
    }

    if (client?.connectionStatus?.state == MqttConnectionState.connected) {
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
    Lights.of(context)
        .lights
        .forEach((light) => client.subscribe(light.topic, MqttQos.exactlyOnce));
  }

  void disconnect() {
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

  void _onMessage(List<MqttReceivedMessage> event) {
    final MqttPublishMessage recMess = event[0].payload as MqttPublishMessage;
    final String message =
        MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

    print('MQTT message: topic is <${event[0].topic}>, '
        'payload is <-- $message -->');

    Lights.of(context)
        .changeLightState(event[0].topic, message == '1' ? true : false);
  }

  void switchHandler(String topic, bool state) {
    _publish(topic, state ? '1' : '0');
  }

  void _publish(String topic, String message) {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();

    builder.addString(message);
    client.publishMessage(topic, MqttQos.values[0], builder.payload,
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
    return MqttState(
      connect,
      disconnect,
      client?.connectionStatus?.state,
      switchHandler,
      allOn,
      allOff,
      child: this.widget.child,
    );
  }
}

class MqttState extends InheritedWidget {
  MqttState(this.connect, this.disconnect, this.connectionState,
      this.switchHandler, this.allOn, this.allOff,
      {Key key, this.child})
      : super(key: key, child: child);

  final Widget child;
  final Function connect;
  final Function disconnect;
  final MqttConnectionState connectionState;
  final Function switchHandler;
  final Function allOn;
  final Function allOff;

  static MqttState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(MqttState) as MqttState);
  }

  @override
  bool updateShouldNotify(MqttState oldWidget) {
    return true;
  }
}
