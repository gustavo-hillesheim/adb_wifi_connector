import 'package:app/core/app_either_adapter.dart';
import 'package:fpdart/fpdart.dart';

abstract class UseCase<Input, Output> {
  Future<AppEitherAdapter<Exception, Output>> call(Input input) async {
    return AppEitherAdapter(await execute(input));
  }

  Future<Either<Exception, Output>> execute(Input input);
}

class NoParams {}