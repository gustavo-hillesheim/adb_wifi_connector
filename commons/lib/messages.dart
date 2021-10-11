abstract class ServerMessages {
  static const hello = 'This is the ADB Wifi Connector Server';
  static const connected = 'Connected';
  static const disconnected = 'Disconnected';
}

abstract class ClientMessages {
  static const connectMe = 'Connect me';
  static const disconnectMe = 'Disconnect me';
  static const whatIsMyStatus = 'What is my status';
}
