import 'dart:async';
import 'dart:io';

import 'package:adb_wifi_connector_commons/messages.dart';
import 'package:adb_wifi_connector_commons/socket_client.dart';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:network_info_plus/network_info_plus.dart';

import '../../domain/component/connector_client_provider.dart';
import '../../domain/model/connector_client.dart';
import '../../domain/model/enum/connection_status.dart';

class SocketConnectorClientProvider implements ConnectorClientProvider {
  @override
  Future<Either<Exception, List<ConnectorClient>>> findServers() async {
    final info = NetworkInfo();
    final ip = await info.getWifiIP();
    debugPrint('Host IP: $ip');
    if (ip == null) {
      return Either.left(Exception('Could not get IP'));
    }
    final subnet = ip.substring(0, ip.lastIndexOf('.'));
    final servers = await _findServers(subnet);
    final clients = await Future.wait(servers.map(_createConnectorClient));
    return Either.right(clients);
  }

  Future<ConnectorClient> _createConnectorClient(
      SocketClient socketClient) async {
    final hostname = await _getName(socketClient);
    return _SocketConnectorClient(hostname, socketClient);
  }

  Future<String> _getName(SocketClient server) {
    final completer = Completer<String>();
    server.send(ClientMessages.whatIsYourName, onAnswer: (message) {
      final data = message.data;
      completer.complete(data);
    });
    return completer.future;
  }

  Future<List<SocketClient>> _findServers(String subnet) async {
    final connectionFutures = <Future>[];
    final servers = <SocketClient>[];
    for (var i = 1; i < 256; i++) {
      final ip = '$subnet.$i';
      final connectionFuture =
          Socket.connect(ip, 14289, timeout: const Duration(seconds: 10))
              .then((socket) async {
                final client = SocketClient(socket);
                final message = await client
                    .getNextMessage(const Duration(milliseconds: 250));
                debugPrint('first message ${message.data}');
                if (message.data == ServerMessages.hello) {
                  return client;
                } else {
                  client.destroy();
                  return null;
                }
              })
              .then((value) => value != null ? servers.add(value) : null)
              .catchError((e) {
                debugPrint('Error while connecting to $ip: $e');
              });
      connectionFutures.add(connectionFuture);
    }
    await Future.wait(connectionFutures);
    return servers;
  }
}

class _SocketConnectorClient implements ConnectorClient {
  @override
  final String hostname;
  final SocketClient _client;

  _SocketConnectorClient(this.hostname, this._client);

  @override
  Future<void> connect() async {
    final completer = Completer<void>();
    await _client.send(ClientMessages.connectMe, onAnswer: (message) async {
      if (message.data == ServerMessages.connected) {
        completer.complete();
      } else {
        completer.completeError(Exception('Unknown error'));
      }
    });
    return completer.future;
  }

  @override
  Future<void> disconnect() async {
    final completer = Completer<void>();
    await _client.send(ClientMessages.disconnectMe, onAnswer: (message) async {
      if (message.data == ServerMessages.disconnected) {
        completer.complete();
      } else {
        completer.completeError(Exception('Unknown error'));
      }
    });
    return completer.future;
  }

  @override
  Future<ConnectionStatus> getStatus() async {
    final completer = Completer<ConnectionStatus>();
    await _client.send(ClientMessages.whatIsMyStatus,
        onAnswer: (message) async {
      completer.complete(connectionStatusFromString(message.data));
    });
    return completer.future;
  }

  @override
  void destroy() {
    _client.destroy();
  }

  @override
  String get address => _client.socket.address.address;
}
