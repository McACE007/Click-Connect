part of 'comment_page_cubit.dart';

sealed class CommentPageState extends Equatable {
  const CommentPageState();

  @override
  List<Object> get props => [];
}

final class CommentPageInitial extends CommentPageState {}

final class CommentPageSelecting extends CommentPageState {
  final int selectedItemCount;
  const CommentPageSelecting({required this.selectedItemCount});

  @override
  List<Object> get props => [selectedItemCount];
}

final class CommentPageReplying extends CommentPageState {
  final CommentEntity comment;

  const CommentPageReplying({required this.comment});

  @override
  List<Object> get props => [comment];
}
