abstract class ConnectorClient {
  String get hostname;
  String get address;

  Future<void> connectMe();
  Future<bool> isConnected();
}