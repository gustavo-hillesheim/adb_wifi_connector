import 'dart:async';
import 'dart:convert';
import 'dart:io';

typedef Listener = FutureOr<void> Function(Message);
typedef Unsubscriber = void Function();

class SocketClient {
  final Socket socket;
  final _listeners = <String, Listener?>{};
  final _idsListeners = <String, Listener?>{};
  int _idSequence = 1;

  SocketClient(this.socket) {
    _listenToMessages();
  }

  void _listenToMessages() {
    utf8.decoder.bind(socket).transform(LineSplitter()).listen((messageStr) {
      print('Received message "$messageStr"');
      final message = Message.fromString(messageStr);
      if (_listeners.containsKey(message.data)) {
        _listeners[message.data]!(message);
      }
      if (_idsListeners.containsKey(message.id)) {
        _idsListeners[message.id]!(message);
      }
    });
  }

  Unsubscriber on(String message, Listener listener) {
    _listeners[message] = listener;
    return () => _listeners.remove(message);
  }

  Unsubscriber onAnswer(String id, Listener listener, {bool once = false}) {
    _idsListeners[id] = (message) {
      if (once) {
        _idsListeners.remove(id);
      }
      listener(message);
    };
    return () => _idsListeners.remove(id);
  }

  Future<void> send(String data, {Listener? onAnswer}) async {
    final id = _generateId();
    await _send(Message(id: id, data: data));
    if (onAnswer != null) {
      this.onAnswer(id, onAnswer, once: true);
    }
  }

  Future<void> answer(
    Message message,
    String data, {
    Listener? onAnswer,
  }) async {
    await _send(Message(id: message.id, data: data));
    if (onAnswer != null) {
      this.onAnswer(message.id, onAnswer, once: true);
    }
  }

  Future<void> _send(Message message) async {
    print('Sending message "$message"');
    socket.writeln(message);
    await socket.flush();
  }

  String _generateId() {
    return '${_idSequence++}';
  }
}

class Message {
  static const separator = ';';
  final String id;
  final String data;

  Message({required this.id, required this.data});

  factory Message.fromString(String message) {
    final separatorIndex = message.indexOf(separator);
    final id = message.substring(0, separatorIndex);
    final data = message.substring(separatorIndex + 1);
    return Message(id: id, data: data);
  }

  @override
  String toString() {
    return '$id$separator$data';
  }
}
