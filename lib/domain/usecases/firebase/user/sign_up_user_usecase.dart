import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../entities/user/user_entity.dart';
import '../../../repositories/firebase_repo.dart';

class SignUpUserUsecase {
  final FirebaseRepo _repo;

  SignUpUserUsecase(this._repo);

  Future<Either<Failure, void>> call(UserEntity user) {
    return _repo.signUpUser(user);
  }
}
