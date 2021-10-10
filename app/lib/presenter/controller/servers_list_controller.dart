import '../../core/usecase.dart';
import '../../domain/model/connector_client.dart';
import '../../domain/usecase/find_servers_usecase.dart';
import 'package:flutter_triple/flutter_triple.dart';

class ServersListController extends StreamStore<Exception, List<ConnectorClient>> {
  final FindServersUsecase usecase;

  ServersListController(this.usecase) : super([]);

  Future<void> findServers() async {
    await executeEither(() => usecase(NoParams()));
  }
}