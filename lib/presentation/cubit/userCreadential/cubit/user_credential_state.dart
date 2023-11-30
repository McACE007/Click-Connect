part of 'user_credential_cubit.dart';

sealed class UserCredentialState extends Equatable {
  const UserCredentialState();

  @override
  List<Object> get props => [];
}

final class UserCredentialInitial extends UserCredentialState {}

final class UserCredentialLoading extends UserCredentialState {}

final class UserCredentialSuccess extends UserCredentialState {}

final class UserCredentialFailure extends UserCredentialState {
  final String errorMessage;
  const UserCredentialFailure({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
