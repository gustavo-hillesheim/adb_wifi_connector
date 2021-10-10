import 'dart:math';

import 'package:adb_wifi_connector_app/domain/model/connector_client.dart';
import 'package:adb_wifi_connector_app/presenter/widget/connector_client_list_tile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_triple/flutter_triple.dart';

class ConnectorClientListTile extends StatefulWidget {
  final ConnectorClient client;

  const ConnectorClientListTile({required this.client, Key? key})
      : super(key: key);

  @override
  _ConnectorClientListTileState createState() =>
      _ConnectorClientListTileState();
}

class _ConnectorClientListTileState extends State<ConnectorClientListTile> {
  late final _controller = ConnectorClientListTileController(widget.client);

  @override
  Widget build(BuildContext context) {
    return TripleBuilder<ConnectorClientListTileController, Exception, Object>(
        store: _controller,
        builder: (context, triple) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black26, width: 1),
              borderRadius: BorderRadius.circular(16),
              color: triple.isLoading ? Colors.black12 : null,
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: triple.isLoading ? null : _controller.connect,
              child: ListTile(
                title: Text(widget.client.hostname,
                    style: Theme.of(context).textTheme.caption),
                subtitle: Text(widget.client.address),
                trailing: triple.isLoading ? const _LoadingIndicator() : const SizedBox.shrink(),
              ),
            ),
          );
        });
  }
}

class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, layout) {
      final smallestSide = min(layout.maxHeight, layout.maxWidth);
      return SizedBox.square(
        child: const Center(child: CircularProgressIndicator()),
        dimension: smallestSide,
      );
    });
  }
}