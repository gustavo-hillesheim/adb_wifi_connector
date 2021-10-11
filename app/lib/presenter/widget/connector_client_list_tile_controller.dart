import 'package:adb_wifi_connector_app/domain/model/connector_client.dart';
import 'package:adb_wifi_connector_app/domain/model/enum/connection_status.dart';
import 'package:flutter_triple/flutter_triple.dart';

class ConnectorClientListTileController
    extends StreamStore<Exception, ConnectionStatus> {
  final ConnectorClient client;

  ConnectorClientListTileController(this.client) : super(ConnectionStatus.disconnecting) {
    setLoading(true);
    client.getStatus().then((v) {
      update(v);
      setLoading(false);
    });
  }

  void connect() async {
    setLoading(true);
    try {
      await client.connect();
      await client.getStatus().then(update);
    } on Exception catch (e) {
      setError(e);
    } finally {
      setLoading(false);
    }
  }

  void disconnect() async {
    setLoading(true);
    try {
      await client.disconnect();
      await client.getStatus().then(update);
    } on Exception catch (e) {
      setError(e);
    } finally {
      setLoading(false);
    }
  }
}
