import '../../../../core/usercases/usercases.dart';
import '../../../../core/utils/typedefs.dart';
import '../../../entities/post/post_entity.dart';
import '../../../repositories/firebase_repo.dart';

class CreatePostUsecase extends UsecaseWithParams<void, PostEntity> {
  final FirebaseRepo _repo;

  CreatePostUsecase(this._repo);

  @override
  ResultFuture call(params) => _repo.createPost(params);
}
