part of 'comment_cubit.dart';

sealed class CommentState extends Equatable {
  const CommentState();

  @override
  List<Object> get props => [];
}

final class CommentInitial extends CommentState {}

final class CommentLoading extends CommentState {}

final class CommentLoaded extends CommentState {
  final List<CommentEntity> comments;

  const CommentLoaded({required this.comments});
  @override
  List<Object> get props => [comments];
}

final class CommentFailure extends CommentState {
  final String errorMessage;
  const CommentFailure({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
