import 'dart:io';

import './process_runner.dart';
import 'package:adb_wifi_connector_commons/messages.dart';
import 'package:adb_wifi_connector_commons/socket_client.dart';

import './exceptions.dart';

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

  void _handleClient(Socket socket) async {
    print('Client ${socket.remoteAddress.address} connected');
    final client = SocketClient(socket);
    await client.send(ServerMessages.hello);

    client.onDestroy(() {
      print('Client ${socket.remoteAddress.address} has disconnected');
    });

    client.on(ClientMessages.connectMe, (message) async {
      final address = client.socket.remoteAddress.address;
      await _processRunner.run('adb', ['connect', address]);
      client.answer(message, ServerMessages.connected);
    });

    client.on(ClientMessages.disconnectMe, (message) async {
      final address = client.socket.remoteAddress.address;
      await _processRunner.run('adb', ['disconnect', address]);
      client.answer(message, ServerMessages.disconnected);
    });

    client.on(ClientMessages.whatIsMyStatus, (message) async {
      final address = client.socket.remoteAddress.address;
      final result = await _processRunner.run('adb', ['devices']);
      final output = result.stdout as String;
      if (output.contains(address)) {
        client.answer(message, ServerMessages.connected);
      } else {
        client.answer(message, ServerMessages.disconnected);
      }
    });
  }
}
