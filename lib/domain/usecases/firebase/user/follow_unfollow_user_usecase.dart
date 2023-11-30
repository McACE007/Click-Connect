import '../../../entities/user/user_entity.dart';
import '../../../repositories/firebase_repo.dart';

class FollowUnfollowUserUsecase {
  final FirebaseRepo _repo;

  FollowUnfollowUserUsecase(this._repo);

  Future<void> call(UserEntity user) {
    return _repo.followUnfollowUser(user);
  }
}
