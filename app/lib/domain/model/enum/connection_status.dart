enum ConnectionStatus { connected, disconnected, connecting, disconnecting }

ConnectionStatus connectionStatusFromString(String status) {
  switch (status.toLowerCase()) {
    case 'connected': return ConnectionStatus.connected;
    case 'disconnected': return ConnectionStatus.disconnected;
    case 'connecting': return ConnectionStatus.connecting;
    case 'disconnecting': return ConnectionStatus.disconnecting;
    default: throw Exception('Unknown connection status "$status"');
  }
}
