enum ConnectionStatus { connected, disconnected }

ConnectionStatus connectionStatusFromString(String status) {
  if (status.toLowerCase() == 'connected') {
    return ConnectionStatus.connected;
  }
  if (status.toLowerCase() == 'disconnected') {
    return ConnectionStatus.disconnected;
  }
  throw Exception('Unkown connection status "$status"');
}
