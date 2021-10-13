import 'package:adb_wifi_connector_app/domain/model/enum/connection_status.dart';

abstract class ConnectorClient {
  String get hostname;
  String get address;

  Future<void> connect();
  Future<void> disconnect();
  Future<ConnectionStatus> getStatus();
  void destroy();
}
