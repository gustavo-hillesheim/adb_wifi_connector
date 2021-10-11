import 'package:flutter/material.dart';
import 'package:flutter_triple/flutter_triple.dart';

import '../../../domain/model/connector_client.dart';
import '../../widget/app_title.dart';
import '../../widget/bottom_card.dart';
import '../../widget/empty.dart';
import '../../widget/primary_button.dart';
import 'servers_list_page_controller.dart';
import 'widget/connector_client_list_tile.dart';

class ServersListPage extends StatefulWidget {
  final ServersListPageController controller;

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
            const Align(
              alignment: Alignment.bottomLeft,
              child: AppTitle(),
            ),
            Expanded(
              child: BottomCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Servers',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                    Expanded(
                      child: ScopedBuilder<ServersListPageController, Exception,
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
                            return Empty(
                              message: 'No server was found',
                              action: PrimaryButton(
                                title: 'Reload',
                                onPressed: widget.controller.findServers,
                              ),
                            );
                          } else {
                            return RefreshIndicator(
                              onRefresh: widget.controller.findServers,
                              child: ListView.separated(
                                itemCount: clients.length,
                                separatorBuilder: (_, __) => const Divider(height: 1),
                                itemBuilder: (context, i) => ConnectorClientListTile(
                                  client: clients.elementAt(i),
                                ),
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
