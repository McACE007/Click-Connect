import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../entities/user/user_entity.dart';
import '../../../repositories/firebase_repo.dart';

class SignInUserUsecase {
  final FirebaseRepo _repo;

  SignInUserUsecase(this._repo);

  Future<Either<Failure, void>> call(UserEntity user) {
    return _repo.signInUser(user);
  }
}
