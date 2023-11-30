import '../../../entities/user/user_entity.dart';
import '../../../repositories/firebase_repo.dart';

class GetAllUsersUsecase {
  final FirebaseRepo _repo;

  GetAllUsersUsecase(this._repo);

  Stream<List<UserEntity>> call() {
    return _repo.getAllUsers();
  }
}
