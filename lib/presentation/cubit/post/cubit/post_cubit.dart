import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../domain/entities/post/post_entity.dart';
import '../../../../domain/usecases/firebase/post/create_post_usecase.dart';
import '../../../../domain/usecases/firebase/post/delete_post_usecase.dart';
import '../../../../domain/usecases/firebase/post/get_posts_usecase.dart';
import '../../../../domain/usecases/firebase/post/like_post_usecase.dart';
import '../../../../domain/usecases/firebase/post/update_post_usecase.dart';

part 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  PostCubit({
    required this.createPostUsecase,
    required this.updatePostUsecase,
    required this.deletePostUsecase,
    required this.likePostUsecase,
    required this.getPostUsecase,
  }) : super(PostInitial());

  final CreatePostUsecase createPostUsecase;
  final UpdatePostUsecase updatePostUsecase;
  final DeletePostUsecase deletePostUsecase;
  final LikePostUsecase likePostUsecase;
  final GetPostUsecase getPostUsecase;

  Future<void> createPost({required PostEntity post}) async {
    final result = await createPostUsecase.call(post);
    result.fold(
      (failure) => emit(PostFailure(errorMessage: failure.errorMessage)),
      (r) => null,
    );
  }

  Future<void> updatePost({required PostEntity post}) async {
    final result = await updatePostUsecase.call(post);
    result.fold(
      (failure) => emit(PostFailure(errorMessage: failure.errorMessage)),
      (r) => null,
    );
  }

  Future<void> deletePost({required PostEntity post}) async {
    final result = await deletePostUsecase.call(post);
    result.fold(
      (failure) => emit(PostFailure(errorMessage: failure.errorMessage)),
      (r) => null,
    );
  }

  Future<void> likePost({required PostEntity post}) async {
    final result = await likePostUsecase.call(post);
    result.fold(
      (failure) => emit(PostFailure(errorMessage: failure.errorMessage)),
      (r) => null,
    );
  }

  Future<void> getPosts() async {
    emit(PostLoading());
    try {
      final streamResponse = getPostUsecase();
      streamResponse.listen((posts) {
        emit(PostLoaded(posts: posts));
      });
    } catch (e) {
      emit(PostFailure(errorMessage: e.toString()));
    }
  }
}
