import '../../../entities/comment/comment_entity.dart';
import '../../../repositories/firebase_repo.dart';

class GetCommentUsecase {
  final FirebaseRepo _repo;

  GetCommentUsecase(this._repo);

  Stream<List<CommentEntity>> call(String postId) => _repo.getComments(postId);
}
