import 'package:adb_wifi_connector_app/presenter/widget/connector_client_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_triple/flutter_triple.dart';

import '../../domain/model/connector_client.dart';
import '../controller/servers_list_controller.dart';

class ServersListPage extends StatefulWidget {
  final ServersListController controller;

  const ServersListPage(this.controller, {Key? key}) : super(key: key);

  @override
  State<ServersListPage> createState() => _ServersListPageState();
}

class _ServersListPageState extends State<ServersListPage> {
  @override
  void initState() {
    super.initState();
    widget.controller.findServers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 48, horizontal: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'ADB WiFi',
                      style: Theme.of(context).textTheme.headline1,
                    ),
                    Text(
                      'Connector',
                      style: Theme.of(context).textTheme.headline2,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 16),
                      child: Text(
                        'Servers',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                    Expanded(
                      child: ScopedBuilder<ServersListController, Exception,
                          List<ConnectorClient>>(
                        store: widget.controller,
                        onLoading: (_) =>
                            const Center(child: CircularProgressIndicator()),
                        onError: (_, error) => Center(
                          child: Text(
                            error.toString(),
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                        onState: (_, clients) {
                          if (clients.isEmpty) {
                            return Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('No server was found'),
                                  const SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: widget.controller.findServers,
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 16),
                                      child: Text('Reload',
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return RefreshIndicator(
                              onRefresh: widget.controller.findServers,
                              child: ListView.separated(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                itemCount: clients.length,
                                separatorBuilder: (_, __) => const Divider(),
                                itemBuilder: (context, i) =>
                                    ConnectorClientListTile(
                                        client: clients.elementAt(i)),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
