import 'package:adb_wifi_connector_app/domain/model/connector_client.dart';
import 'package:flutter_triple/flutter_triple.dart';

class ConnectorClientListTileController
    extends StreamStore<Exception, _NoResult> {
  final ConnectorClient client;

  ConnectorClientListTileController(this.client) : super(_NoResult());

  Future<void> connect() async {
    setLoading(true);
    try {
      await client.connect();
      update(_NoResult());
    } on Exception catch (e) {
      setError(e);
    } finally {
      setLoading(false);
    }
  }

  Future<void> disconnect() async {
    setLoading(true);
    try {
      await client.disconnect();
      update(_NoResult());
    } on Exception catch (e) {
      setError(e);
    } finally {
      setLoading(false);
    }
  }
}

class _NoResult {}
