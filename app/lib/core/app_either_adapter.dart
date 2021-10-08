import 'package:flutter_triple/flutter_triple.dart';
import 'package:fpdart/fpdart.dart';

class AppEitherAdapter<Left, Right> implements EitherAdapter<Left, Right> {
  final Either<Left, Right> _either;

  AppEitherAdapter(this._either);

  @override
  T fold<T>(T Function(Left) leftF, T Function(Right) rightF) {
    return _either.fold(leftF, rightF);
  }

}