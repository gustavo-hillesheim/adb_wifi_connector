import 'dart:io';

import 'package:fpdart/src/either.dart';
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
          .map((socket) => _SocketConnectorClient(socket))
          .toList();
    return Either.right(clients);
  }

  Future<List<Socket>> _findServers(String subnet) async {
    final connectionFutures = <Future>[];
    final servers = <Socket>[];
    for (var i = 1; i < 256; i++) {
      final ip = '$subnet.$i';
      final connectionFuture = Socket.connect(ip, 14289, timeout: const Duration(seconds: 1))
          .then((value) => servers.add(value))
          .catchError((_) {});
      connectionFutures.add(connectionFuture);
    }
    await Future.wait(connectionFutures);
    return servers;
  }
}

class _SocketConnectorClient implements ConnectorClient {
  final Socket _socket;

  _SocketConnectorClient(this._socket);

  @override
  Future<void> connectMe() async {
    _socket.writeln('Connect me');
    await _socket.flush();
  }

  @override
  String get hostname => _socket.address.host;

  @override
  String get address => _socket.address.address;
}
