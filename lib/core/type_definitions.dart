import 'package:fpdart/fpdart.dart';
import 'package:the_iconic/errors/responses.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureEitherVoid = FutureEither<void>;
typedef FutureVoid = Future<void>;
