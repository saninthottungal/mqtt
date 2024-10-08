import 'dart:developer';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttClient {
  MqttClient._internal()
      : client = MqttServerClient.withPort(
          Constants._server,
          Constants._clientIdentifier,
          1883,
        ) {
    initialize();
  }

  final MqttServerClient client;
  static final MqttClient _client = MqttClient._internal();

  factory MqttClient() {
    return _client;
  }

  void initialize() {
    client
      ..keepAlivePeriod = 60
      ..connectionMessage = (MqttConnectMessage()
        ..startClean()
        ..withWillQos(MqttQos.atLeastOnce))
      ..onConnected = onConnected
      ..onDisconnected = onDisconnected
      ..onSubscribed = onSubscribed
      ..onSubscribeFail = onSubscribeFail
      ..updates?.listen(onUpdates);
  }

  Future<void> connect() async {
    await client.connect();
  }

  void onConnected() {
    log("yayy..... Connected");
  }

  void onDisconnected() {
    log("oooppsss...disconnected");
  }

  void onSubscribed(String topic) {
    log("subscribed to $topic");
  }

  void onSubscribeFail(String err) {
    log("subscribing failed : $err");
  }

  void onUpdates(List<MqttReceivedMessage<MqttMessage>> recMessages) {
    final recMessage = recMessages[0].payload as MqttPublishMessage;
    final payLoad =
        MqttPublishPayload.bytesToStringAsString(recMessage.payload.message);
    print("recived message $payLoad from topic ${recMessages[0].topic}");
  }
}

class Constants {
  static const _server = 'broker.emqx.io';
  static const _clientIdentifier = 'flutter_client';
}
