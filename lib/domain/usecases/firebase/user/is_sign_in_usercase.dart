import '../../../repositories/firebase_repo.dart';

class IsSignInUsecase {
  final FirebaseRepo _repo;

  IsSignInUsecase(this._repo);

  Future<bool> call() {
    return _repo.isSignIn();
  }
}
