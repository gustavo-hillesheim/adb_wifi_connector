import 'package:app/core/usecase.dart';
import 'package:app/domain/model/connector_client.dart';
import 'package:app/domain/usecase/find_servers_usecase.dart';
import 'package:flutter_triple/flutter_triple.dart';

class ServersListController extends StreamStore<Exception, List<ConnectorClient>> {
  final FindServersUsecase usecase;

  ServersListController(this.usecase) : super([]);

  Future<void> findServers() async {
    await executeEither(() => usecase(NoParams()));
  }
}