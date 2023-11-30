part of 'post_cubit.dart';

sealed class PostState extends Equatable {
  const PostState();

  @override
  List<Object> get props => [];
}

final class PostInitial extends PostState {}

final class PostLoading extends PostState {}

final class PostLoaded extends PostState {
  final List<PostEntity> posts;

  const PostLoaded({required this.posts});
  @override
  List<Object> get props => [posts];
}

final class PostFailure extends PostState {
  final String errorMessage;
  const PostFailure({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
