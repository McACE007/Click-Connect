import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../domain/entities/comment/comment_entity.dart';

part 'comment_page_state.dart';

class CommentPageCubit extends Cubit<CommentPageState> {
  CommentPageCubit() : super(CommentPageInitial());

  void isSelecting({required int selectedItemCount}) {
    emit(CommentPageSelecting(selectedItemCount: selectedItemCount));
  }

  void isReplying({required CommentEntity comment}) {
    emit(CommentPageReplying(comment: comment));
  }
}
