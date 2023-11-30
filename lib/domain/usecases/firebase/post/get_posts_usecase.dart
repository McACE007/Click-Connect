import '../../../entities/post/post_entity.dart';
import '../../../repositories/firebase_repo.dart';

class GetPostUsecase {
  final FirebaseRepo _repo;

  GetPostUsecase(this._repo);

  Stream<List<PostEntity>> call() {
    return _repo.getPosts();
  }
}
