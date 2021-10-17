ADB WiFi Connector is used to connect Android phones to ADB through WiFi.<br>
It consists of a socket server that listens for connections and messages, and an app that connects to this server and send messages to connect or disconnect from ADB.

# Showcase
![ADB Wifi Connector Showcase](docs/showcase.gif)

# Key Dart features used
- Socket server
- UTF-8 encoding
- Typedefs
- Futures

# Key Flutter features used
- Stateless and Stateful widgets
- Custom themes for color and text
- Pull to refresh list
- Flutter Version Management (FVM)
- State management with [Flutter Triple](https://pub.dev/packages/flutter_triple)
- Functional programming style returns with [FP Dart](https://pub.dev/packages/fpdart)
- Launcher icons with [Flutter Launcher Icons](https://pub.dev/packages/flutter_launcher_icons)

# Architecture
The app is architectured following Clean Architecture principles. It is separated into the following layers:
- Domain: contains the base models, component interfaces and usecases;
- Data: implements the component interfaces;
- Presenter: Implements the UI.

There is also the Core "layer", that implements general use classes, and the Commons package, that implements common socket message handling and socket messages.