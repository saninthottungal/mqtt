class MqttClient {
  MqttClient._internal();
  static final MqttClient _client = MqttClient._internal();

  factory MqttClient() {
    return _client;
  }
}
