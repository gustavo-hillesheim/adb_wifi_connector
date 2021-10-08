import 'package:app/core/usecase.dart';
import 'package:app/domain/component/connector_client_provider.dart';
import 'package:app/domain/model/connector_client.dart';
import 'package:fpdart/src/either.dart';

class FindServersUsecase extends UseCase<NoParams, List<ConnectorClient>> {
  final ConnectorClientProvider provider;

  FindServersUsecase(this.provider);

  @override
  Future<Either<Exception, List<ConnectorClient>>> execute(NoParams input) {
    return provider.findServers();
  }
}