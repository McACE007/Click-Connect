import '../../../entities/user/user_entity.dart';
import '../../../repositories/firebase_repo.dart';

class UpdateUserUsecase {
  final FirebaseRepo _repo;

  UpdateUserUsecase(this._repo);

  Future<void> call(UserEntity user) {
    return _repo.updateUser(user);
  }
}
