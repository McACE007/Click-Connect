import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../domain/entities/comment/comment_entity.dart';
import '../../../../domain/usecases/firebase/comment/create_comment_usecase.dart';
import '../../../../domain/usecases/firebase/comment/delete_comment_usecase.dart';
import '../../../../domain/usecases/firebase/comment/get_comment_usecase.dart';
import '../../../../domain/usecases/firebase/comment/like_comment_usecase.dart';
import '../../../../domain/usecases/firebase/comment/update_comment_usecase.dart';

part 'comment_state.dart';

class CommentCubit extends Cubit<CommentState> {
  CommentCubit({
    required this.createCommentUsecase,
    required this.updateCommentUsecase,
    required this.deleteCommentUsecase,
    required this.likeCommentUsecase,
    required this.getCommentUsecase,
  }) : super(CommentInitial());

  final CreateCommentUsecase createCommentUsecase;
  final UpdateCommentUsecase updateCommentUsecase;
  final DeleteCommentUsecase deleteCommentUsecase;
  final LikeCommentUsecase likeCommentUsecase;
  final GetCommentUsecase getCommentUsecase;

  Future<void> createComment({required CommentEntity comment}) async {
    final result = await createCommentUsecase.call(comment);
    result.fold(
      (failure) => emit(CommentFailure(errorMessage: failure.errorMessage)),
      (r) => null,
    );
  }

  Future<void> updateComment({required CommentEntity comment}) async {
    final result = await updateCommentUsecase.call(comment);
    result.fold(
      (failure) => emit(CommentFailure(errorMessage: failure.errorMessage)),
      (r) => null,
    );
  }

  Future<void> deleteComment({required CommentEntity comment}) async {
    final result = await deleteCommentUsecase.call(comment);
    result.fold(
      (failure) => emit(CommentFailure(errorMessage: failure.errorMessage)),
      (r) => null,
    );
  }

  Future<void> likeComment({required CommentEntity comment}) async {
    final result = await likeCommentUsecase.call(comment);
    result.fold(
      (failure) => emit(CommentFailure(errorMessage: failure.errorMessage)),
      (r) => null,
    );
  }

  Future<void> getComments(String postId) async {
    emit(CommentLoading());
    try {
      final streamResponse = getCommentUsecase(postId);
      streamResponse.listen((comments) {
        emit(CommentLoaded(comments: comments));
      });
    } catch (e) {
      emit(CommentFailure(errorMessage: e.toString()));
    }
  }
}
