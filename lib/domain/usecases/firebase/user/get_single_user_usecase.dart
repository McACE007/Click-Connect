import '../../../entities/user/user_entity.dart';
import '../../../repositories/firebase_repo.dart';

class GetSingleUserUsecase {
  final FirebaseRepo _repo;

  GetSingleUserUsecase(this._repo);

  Stream<List<UserEntity>> call(String uid) {
    return _repo.getSingleUser(uid);
  }
}
