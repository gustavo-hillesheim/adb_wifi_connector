A socket server used to connect an Android phone to ADB via Wifi.

# How it works

The server starts listens for connections at port 14289, when a client connects it sends a message to the client so that the client knows this is the ADB Wifi Connector Server.
If the client wants to be connect to ADB, it sends a "connectMe" message, the server then runs the commands `adb tcpip 5555` and `adb connect $clientIp`.