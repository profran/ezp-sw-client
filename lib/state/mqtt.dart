import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:sigv4/sigv4.dart';

import 'modules.dart';
import 'settings.dart';

const serviceName = 'iotdevicegateway';
const awsS4Request = 'aws4_request';
const aws4HmacSha256 = 'AWS4-HMAC-SHA256';
const scheme = 'wss://';
const urlPath = '/mqtt';

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
    print(getBsSignedUrl());
    if (_settings.usesAWSIotCore) {
      client = MqttClient(getBsSignedUrl(), 'Flutter app');
      client.port = 443;
      client.useWebSocket = true;
    } else {
      client = MqttClient(_settings.brokerURL, 'Flutter app');
      client.port = _settings.brokerPort ?? 1883;
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

  String getBsSignedUrl() {
    var now = _generateDatetime();
    var region = 'us-east-2';
    var credentials = {
      "accessKey": _settings.brokerUsername,
      "secretKey": _settings.brokerPassword,
    };
    var endpoint = _settings.brokerURL;

    var creds = [
      credentials['accessKey'],
      _getDate(now),
      region,
      serviceName,
      awsS4Request,
    ];
    var queryParams = {
      'X-Amz-Algorithm': aws4HmacSha256,
      'X-Amz-Credential': creds.join('/'),
      'X-Amz-Date': now,
      'X-Amz-SignedHeaders': 'host',
    };

    var canonicalQueryString = Sigv4.buildCanonicalQueryString(queryParams);
    var request = Sigv4.buildCanonicalRequest(
      'GET',
      urlPath,
      queryParams,
      {'host': endpoint},
      '',
    );

    var hashedCanonicalRequest = Sigv4.hashPayload(request);
    var stringToSign = Sigv4.buildStringToSign(
      now,
      Sigv4.buildCredentialScope(now, region, serviceName),
      hashedCanonicalRequest,
    );

    var signingKey = Sigv4.calculateSigningKey(
      credentials['secretKey'],
      now,
      region,
      serviceName,
    );

    var signature = Sigv4.calculateSignature(signingKey, stringToSign);

    var finalParams = '$canonicalQueryString&X-Amz-Signature=$signature';

    return '$scheme$endpoint$urlPath?$finalParams';
  }

  String _generateDatetime() {
    return new DateTime.now()
        .toUtc()
        .toString()
        .replaceAll(new RegExp(r'\.\d*Z$'), 'Z')
        .replaceAll(new RegExp(r'[:-]|\.\d{3}'), '')
        .split(' ')
        .join('T');
  }

  String _getDate(String dateTime) {
    return dateTime.substring(0, 8);
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
    client.subscribe(topic, MqttQos.atLeastOnce);
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
    this.client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload);
  }

  void _broadcast(String message) {
    this._modules.modules.forEach((module) => _publish(module.topic, message));
  }
}
