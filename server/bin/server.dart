import 'package:adb_wifi_connector_server/src/connector_server.dart';

void main(List<String> arguments) async {
  const kServerPort = 14289;
  ConnectorServer.bind(kServerPort);
  print('ADB Wifi Connector Server has started at port $kServerPort');
}
