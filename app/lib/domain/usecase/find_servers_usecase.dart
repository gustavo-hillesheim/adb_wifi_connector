import '../../core/usecase.dart';
import '../../domain/component/connector_client_provider.dart';
import '../../domain/model/connector_client.dart';
import 'package:fpdart/fpdart.dart';

class FindServersUsecase extends UseCase<NoParams, List<ConnectorClient>> {
  final ConnectorClientProvider provider;

  FindServersUsecase(this.provider);

  @override
  Future<Either<Exception, List<ConnectorClient>>> execute(NoParams input) {
    return provider.findServers();
  }
}
