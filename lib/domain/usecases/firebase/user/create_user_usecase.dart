import '../../../entities/user/user_entity.dart';
import '../../../repositories/firebase_repo.dart';

class CreateUserUsecase {
  final FirebaseRepo _repo;

  CreateUserUsecase(this._repo);

  Future<void> call(UserEntity user, String profileUrl) {
    return _repo.createUserWithImage(user, profileUrl);
  }
}
