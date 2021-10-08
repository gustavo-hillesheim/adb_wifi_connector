import 'package:app/domain/model/connector_client.dart';
import 'package:fpdart/fpdart.dart';

abstract class ConnectorClientProvider {
  Future<Either<Exception, List<ConnectorClient>>> findServers();
}