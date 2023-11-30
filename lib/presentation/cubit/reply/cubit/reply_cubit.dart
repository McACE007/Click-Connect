import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../domain/entities/reply/reply_entity.dart';
import '../../../../domain/usecases/firebase/reply/create_reply_usecase.dart';
import '../../../../domain/usecases/firebase/reply/delete_reply_usecase.dart';
import '../../../../domain/usecases/firebase/reply/get_replys_usecase.dart';
import '../../../../domain/usecases/firebase/reply/like_reply_usecase.dart';

part 'reply_state.dart';

class ReplyCubit extends Cubit<ReplyState> {
  ReplyCubit({
    required this.createReplyUsecase,
    required this.deleteReplyUsecase,
    required this.likeReplyUsecase,
    required this.getReplysUsecase,
  }) : super(ReplyInitial());

  final CreateReplyUsecase createReplyUsecase;
  final DeleteReplyUsecase deleteReplyUsecase;
  final LikeReplyUsecase likeReplyUsecase;
  final GetReplysUsecase getReplysUsecase;
  bool isReplying = false;

  Future<void> createReply({required ReplyEntity reply}) async {
    final result = await createReplyUsecase.call(reply);
    result.fold(
      (failure) => emit(ReplyFailure(errorMessage: failure.errorMessage)),
      (r) => null,
    );
  }

  Future<void> deleteReply({required ReplyEntity reply}) async {
    final result = await deleteReplyUsecase.call(reply);
    result.fold(
      (failure) => emit(ReplyFailure(errorMessage: failure.errorMessage)),
      (r) => null,
    );
  }

  Future<void> likeReply({required ReplyEntity reply}) async {
    final result = await likeReplyUsecase.call(reply);
    result.fold(
      (failure) => emit(ReplyFailure(errorMessage: failure.errorMessage)),
      (r) => null,
    );
  }

  Future<void> getReplys({required ReplyEntity reply}) async {
    emit(ReplyLoading());
    try {
      final streamResponse = getReplysUsecase(reply);
      streamResponse.listen((replys) {
        emit(ReplyLoaded(replys: replys));
      });
    } catch (e) {
      emit(ReplyFailure(errorMessage: e.toString()));
    }
  }
}
