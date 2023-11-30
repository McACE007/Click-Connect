part of 'user_cubit.dart';

sealed class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

final class UserInitial extends UserState {}

final class UserLoading extends UserState {}

final class UsersLoaded extends UserState {
  final List<UserEntity> users;

  const UsersLoaded({required this.users});
  @override
  List<Object> get props => [users];
}

final class UserFailure extends UserState {
  final String errorMessage;
  const UserFailure({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
