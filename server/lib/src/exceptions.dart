class ServerAlreadyStartedException implements Exception {
  final String message;
  final int port;

  ServerAlreadyStartedException(this.port)
      : message = 'The server is already started at port: $port';
}
