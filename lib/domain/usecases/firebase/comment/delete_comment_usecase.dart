import '../../../../core/usercases/usercases.dart';
import '../../../../core/utils/typedefs.dart';
import '../../../entities/comment/comment_entity.dart';
import '../../../repositories/firebase_repo.dart';

class DeleteCommentUsecase extends UsecaseWithParams<void, CommentEntity> {
  const DeleteCommentUsecase(this._repo);
  final FirebaseRepo _repo;

  @override
  ResultFuture call(params) => _repo.deleteComment(params);
}
