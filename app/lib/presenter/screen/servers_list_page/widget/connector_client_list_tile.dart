import '../../../../domain/model/connector_client.dart';
import '../../../../domain/model/enum/connection_status.dart';
import 'connector_client_list_tile_controller.dart';
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
    return TripleBuilder<ConnectorClientListTileController, Exception,
        ConnectionStatus>(
      store: _controller,
      builder: (context, triple) {
        final onTapChangeStatus = triple.isLoading
            ? null
            : (triple.state == ConnectionStatus.connected
                ? _controller.disconnect
                : _controller.connect);
        return Material(
          color: Colors.white,
          child: Stack(
            children: [
              InkWell(
                focusColor: Colors.white,
                onTap: onTapChangeStatus,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ListTile(
                    title: Text(
                      widget.client.hostname,
                      style: Theme.of(context).textTheme.caption,
                    ),
                    subtitle: Text(widget.client.address),
                    trailing: _ConnectionStatus(
                      status: triple.state,
                      onTapChange: onTapChangeStatus,
                    ),
                  ),
                ),
              ),
              if (triple.isLoading)
                const Positioned(
                  child: _ConnectingOverlay(),
                  left: 0,
                  right: 0,
                  top: 0,
                  bottom: 0,
                ),
            ],
          ),
        );
      },
    );
  }
}

class _ConnectingOverlay extends StatelessWidget {
  const _ConnectingOverlay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black26,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class _ConnectionStatus extends StatelessWidget {
  final ConnectionStatus status;
  final VoidCallback? onTapChange;

  const _ConnectionStatus({
    required this.status,
    required this.onTapChange,
  });

  @override
  Widget build(BuildContext context) {
    final isConnected = status == ConnectionStatus.connected;
    return Switch(
      value: isConnected,
      onChanged: (_) {
        if (onTapChange != null) {
          onTapChange!();
        }
      },
    );
  }
}
