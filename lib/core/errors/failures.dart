import 'package:equatable/equatable.dart';

import 'exception.dart';

abstract class Failure extends Equatable {
  final String errorMessage;
  const Failure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

class AuthFailure extends Failure {
  const AuthFailure(super.errorMessage);

  factory AuthFailure.fromException(AuthException exception) {
    return AuthFailure(exception.errorMessage);
  }
}

class ServerFailure extends Failure {
  const ServerFailure(super.errorMessage);

  factory ServerFailure.fromException(ServerException exception) {
    return ServerFailure(exception.errorMessage);
  }
}
