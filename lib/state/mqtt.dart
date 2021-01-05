import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';

import 'modules.dart';
import 'settings.dart';

class MqttProvider extends ChangeNotifier {
  SettingsProvider _settings;
  ModulesProvider _modules;

  MqttClient client;
  MqttConnectionState connectionState = MqttConnectionState.disconnected;
  StreamSubscription subscription;

  set settings(SettingsProvider settings) {
    this._settings = settings;
  }

  set modules(ModulesProvider modules) {
    this._modules = modules;
  }

  void connect() async {
    print(_settings.brokerURL);
    client = MqttClient(_settings.brokerURL, 'Flutter app');

    if (_settings.brokerPort != null) {
      client.port = _settings.brokerPort;
    }
    client.logging(on: true);
    client.onDisconnected = _onDisconnected;
    client.onConnected = _onConnected;

    try {
      this.client.connectionStatus.state = MqttConnectionState.connecting;
      notifyListeners();

      await this
          .client
          .connect(_settings.brokerUsername, _settings.brokerPassword);
    } catch (e) {
      print(e);
      disconnect();
    }

    if (this.client?.connectionStatus?.state == MqttConnectionState.connected) {
    } else {
      print('ERROR: MQTT client connection failed - '
          'disconnecting, state is ${client?.connectionStatus?.state}');
    }
  }

  void _onConnected() {
    print('MQTT client connected');

    this.connectionState = MqttConnectionState.connected;
    notifyListeners();

    subscription = client.updates.listen(_onMessage);
    _subscribeAll();
  }

  void disconnect() {
    client.disconnect();
  }

  void _onDisconnected() {
    this.connectionState = MqttConnectionState.disconnected;
    this.client = null;
    this.subscription?.cancel();
    this.subscription = null;
  }

  void _onMessage(List<MqttReceivedMessage> event) {
    final MqttPublishMessage recMess = event[0].payload as MqttPublishMessage;
    final String message =
        MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

    print('MQTT message: topic is <${event[0].topic}>, '
        'payload is <-- $message -->');

    _modules.changeModuleState(event[0].topic, message);
  }

  void subscribe(String topic) {
    client.subscribe(topic, MqttQos.exactlyOnce);
  }

  void _subscribeAll() {
    List<String> topics = [];
    for (var mod in _modules.modules) {
      if (client.getSubscriptionsStatus(mod.topic) ==
          MqttSubscriptionStatus.doesNotExist) {
        topics.add(mod.topic);
      }
    }

    topics.forEach((topic) => subscribe(topic));
  }

  void switchHandler(String topic, bool state) {
    this._publish(topic, state ? '1' : '0');
  }

  void _publish(String topic, String message) {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();

    builder.addString(message);
    this.client.publishMessage(topic, MqttQos.values[0], builder.payload,
        retain: true);
  }

  void _broadcast(String message) {
    this._modules.modules.forEach((module) => _publish(module.topic, message));
  }
}
