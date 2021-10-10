import 'package:adb_wifi_connector_app/domain/model/connector_client.dart';
import 'package:flutter_triple/flutter_triple.dart';

class ConnectorClientListTileController extends StreamStore<Exception, _NoResult> {
  final ConnectorClient client;

  ConnectorClientListTileController(this.client) : super(_NoResult());

  Future<void> connect() async {
    execute(() async {
      await client.connectMe();
      return _NoResult();
    });
  }
}

class _NoResult {}