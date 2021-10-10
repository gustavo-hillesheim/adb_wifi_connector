import './data/component/socket_connector_client_provider.dart';
import './domain/usecase/find_servers_usecase.dart';
import './presenter/controller/servers_list_controller.dart';
import './presenter/screen/servers_list_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ADB Wifi Connector',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        textTheme: const TextTheme(
          headline1: TextStyle(fontWeight: FontWeight.bold, fontSize: 54),
          headline2: TextStyle(fontWeight: FontWeight.bold, fontSize: 46),
          bodyText1: TextStyle(fontSize: 28),
          caption: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      home: ServersListPage(
        ServersListController(
            FindServersUsecase(SocketConnectorClientProvider())),
      ),
    );
  }
}
