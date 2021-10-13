import 'dart:async';
import 'dart:convert';
import 'dart:io';

typedef Listener = FutureOr<void> Function(Message);
typedef Unsubscriber = void Function();

class SocketClient {
  final Socket socket;
  final _messageListeners = <String, Listener?>{};
  final _idsListeners = <String, Listener?>{};
  final _listeners = <Listener>[];
  final _destroyListeners = <void Function()>[];
  int _idSequence = 1;

  SocketClient(this.socket) {
    _listenToMessages();
  }

  void destroy() {
    socket.close();
    socket.destroy();
    _listeners.clear();
    _messageListeners.clear();
    _idsListeners.clear();
    _destroyListeners.clear();
  }

  Unsubscriber onDestroy(void Function() listener) {
    _destroyListeners.add(listener);
    return () => _destroyListeners.remove(listener);
  }

  Unsubscriber onReceiveMessage(Listener listener) {
    _listeners.add(listener);
    return () => _listeners.remove(listener);
  }

  Future<Message> getNextMessage(Duration timeout) {
    final completer = Completer<Message>();
    late Timer timer;
    late Unsubscriber unsubscriber;
    unsubscriber = onReceiveMessage((message) {
      completer.complete(message);
      unsubscriber();
      timer.cancel();
    });
    timer = Timer(timeout, () {
      if (!completer.isCompleted) {
        unsubscriber();
        completer.completeError(Exception('Reached timeout'));
      }
    });
    return completer.future;
  }

  Unsubscriber on(String message, Listener listener) {
    _messageListeners[message] = listener;
    return () => _messageListeners.remove(message);
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

  void _listenToMessages() {
    utf8.decoder.bind(socket).transform(LineSplitter()).listen((messageStr) {
      print('Received message "$messageStr"');
      final message = Message.fromString(messageStr);
      if (_messageListeners.containsKey(message.data)) {
        _messageListeners[message.data]!(message);
      }
      if (_idsListeners.containsKey(message.id)) {
        _idsListeners[message.id]!(message);
      }
      final listenersCopy = [..._listeners];
      for (final listener in listenersCopy) {
        listener(message);
      }
    }, onDone: () {
      final destroyListenersCopy = [..._destroyListeners];
      for (final listener in destroyListenersCopy) {
        listener();
      }
    });
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
