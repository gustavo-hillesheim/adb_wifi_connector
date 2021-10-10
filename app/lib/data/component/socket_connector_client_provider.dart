import 'dart:async';
import 'dart:io';

import 'package:adb_wifi_connector_commons/messages.dart';
import 'package:adb_wifi_connector_commons/socket_client.dart';
import 'package:fpdart/fpdart.dart';
import 'package:network_info_plus/network_info_plus.dart';

import '../../domain/component/connector_client_provider.dart';
import '../../domain/model/connector_client.dart';

class SocketConnectorClientProvider implements ConnectorClientProvider {
  @override
  Future<Either<Exception, List<ConnectorClient>>> findServers() async {
    final info = NetworkInfo();
    final ip = await info.getWifiIP();
    if (ip == null) {
      return Either.left(Exception('Could not get IP'));
    }
    final subnet = ip.substring(0, ip.lastIndexOf('.'));
    final clients = (await _findServers(subnet))
        .map((socket) => _SocketConnectorClient(SocketClient(socket)))
        .toList();
    return Either.right(clients);
  }

  Future<List<Socket>> _findServers(String subnet) async {
    final connectionFutures = <Future>[];
    final servers = <Socket>[];
    for (var i = 1; i < 256; i++) {
      final ip = '$subnet.$i';
      final connectionFuture =
          Socket.connect(ip, 14289, timeout: const Duration(seconds: 1))
              .then((value) => servers.add(value))
              .catchError((_) {});
      connectionFutures.add(connectionFuture);
    }
    await Future.wait(connectionFutures);
    return servers;
  }
}

class _SocketConnectorClient implements ConnectorClient {
  final SocketClient _client;

  _SocketConnectorClient(this._client);

  @override
  Future<void> connectMe() async {
    final completer = Completer<void>();
    _client.send(ClientMessages.connectMe, onAnswer: (message) async {
      if (message.data == ServerMessages.connected) {
        completer.complete();
      } else {
        completer.completeError(Exception('Unknown error'));
      }
    });
    return completer.future;
  }

  @override
  Future<bool> isConnected() {
    final completer = Completer<bool>();
    _client.send(ClientMessages.amIConnected, onAnswer: (message) async {
      completer.complete(message.data == ServerMessages.yes);
    });
    return completer.future;
  }

  @override
  String get hostname => _client.socket.address.host;

  @override
  String get address => _client.socket.address.address;
}
