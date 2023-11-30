import 'package:equatable/equatable.dart';

class Exception extends Equatable {
  final String errorMessage;
  const Exception(this.errorMessage);
  @override
  List<Object?> get props => [errorMessage];
}

class ServerException extends Exception {
  const ServerException(super.errorMessage);
}

class AuthException extends Exception {
  const AuthException(super.msg);
}
