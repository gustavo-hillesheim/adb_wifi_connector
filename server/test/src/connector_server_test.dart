import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:adb_wifi_connector_server/src/connector_server.dart';
import 'package:adb_wifi_connector_server/src/exceptions.dart';
import 'package:adb_wifi_connector_server/src/messages.dart';
import 'package:adb_wifi_connector_server/src/process_runner.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() async {
  const kServerPort = 1234;
  final processRunner = ProcessRunnerMock();
  final ConnectorServer server = ConnectorServer(kServerPort, processRunner);
  // The server needs to be started only once, so using the setUp function does not work
  await server.start(kServerPort);

  test(
    'clients should be able to connect to server using localhost, ip address or host name',
    () async {
      await Socket.connect('localhost', kServerPort);
      await Socket.connect('127.0.0.1', kServerPort);
      await Socket.connect(Platform.localHostname, kServerPort);
    },
  );

  test(
    'WHEN trying to start a server that is already started SHOULD throw an exception',
    () async {
      try {
        await server.start(kServerPort);
        fail('Should have thrown exception');
      } catch (e) {
        expect(e, isA<ServerAlreadyStartedException>());
        expect((e as ServerAlreadyStartedException).port, kServerPort);
      }
    },
  );

  test(
    'WHEN a client connects, the server SHOULD send a "hello" message',
    () async {
      final socket = await Socket.connect('localhost', kServerPort);
      final message = await utf8.decoder
          .bind(socket)
          .transform(LineSplitter())
          .timeout(Duration(milliseconds: 100))
          .first;
      expect(message, ServerMessages.hello);
    },
  );

  test(
    'WHEN a client sends a "connectMe" message, the server SHOULD run adb commands to connect the client',
    () async {
      final socket = await Socket.connect('localhost', kServerPort);
      socket.writeln(ClientMessages.connectMe);
      await socket.flush();

      // Needs to delay so that the server has time to process the message
      await Future.delayed(Duration(milliseconds: 100));
      verify(() => processRunner.run('adb', ['tcpip', '5555']));
      verify(() => processRunner.run('adb', ['connect', '0.0.0.0']));
    },
  );

  test(
    'the "bind" method SHOULD return a started server at the given port',
    () async {
      final server = await ConnectorServer.bind(4321);
      expect(server.port, 4321);
      expect(server.isStarted, true);
      await Socket.connect('localhost', 4321);
    },
  );
}

class ProcessRunnerMock extends Mock implements ProcessRunner {}
