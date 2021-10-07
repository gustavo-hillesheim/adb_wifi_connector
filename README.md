ADB Wifi Connector consists of a server and a mobile app, both of them are used to connect Android phones to ADB via Wifi easily.

# How it works

A socket server is started in the computer, listening for connections from mobile clients.
When a client connects to the server, it can send a "connectMe" message to the server, which will then run the commands `adb tcpip 5555` and `adb connect $clientIp` in order to connect the client to ADB.