part of 'reply_cubit.dart';

sealed class ReplyState extends Equatable {
  const ReplyState();

  @override
  List<Object> get props => [];
}

final class ReplyInitial extends ReplyState {}

final class ReplyLoading extends ReplyState {}

final class ReplyLoaded extends ReplyState {
  final List<ReplyEntity> replys;

  const ReplyLoaded({required this.replys});
  @override
  List<Object> get props => [replys];
}

final class ReplyFailure extends ReplyState {
  final String errorMessage;
  const ReplyFailure({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
