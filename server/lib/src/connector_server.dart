import 'dart:convert';
import 'dart:io';

import 'package:adb_wifi_connector_server/src/process_runner.dart';

import './exceptions.dart';
import './messages.dart';

class ConnectorServer {
  final ProcessRunner _processRunner;
  late final ServerSocket _server;
  final int port;
  bool _isStarted = false;

  bool get isStarted => _isStarted;

  ConnectorServer(this.port, this._processRunner);

  static Future<ConnectorServer> bind(int port) async {
    final server = ConnectorServer(port, ProcessRunner());
    await server.start(port);
    return server;
  }

  Future<void> start(int port) async {
    if (_isStarted) {
      throw ServerAlreadyStartedException(_server.port);
    }
    // It is required to use '0.0.0.0' as address so that clients can connect
    // using IP or hostname
    _server = await ServerSocket.bind('0.0.0.0', port);
    _server.listen(_handleClient);
    _isStarted = true;
  }

  void _handleClient(Socket client) async {
    client.writeln(ServerMessages.hello);
    await client.flush();

    final messagesStream = utf8.decoder.bind(client).transform(LineSplitter());
    messagesStream.listen((message) async {
      if (message == ClientMessages.connectMe) {
        final address = client.remoteAddress.address;
        print('Connecting $address');
        await _processRunner.run('adb', ['connect', address]);
      }
    });
  }
}
