import '../../../core/usecase.dart';
import '../../../domain/model/connector_client.dart';
import '../../../domain/usecase/find_servers_usecase.dart';
import 'package:flutter_triple/flutter_triple.dart';

class ServersListPageController
    extends StreamStore<Exception, List<ConnectorClient>> {
  final FindServersUsecase usecase;

  ServersListPageController(this.usecase) : super([]);

  Future<void> findServers() {
    return executeEither(() {
      for (var client in state) {
        client.destroy();
      }
      return usecase(NoParams());
    });
  }
}
