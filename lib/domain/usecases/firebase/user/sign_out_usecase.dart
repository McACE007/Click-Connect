import '../../../repositories/firebase_repo.dart';

class SignOutUsecase {
  final FirebaseRepo _repo;

  SignOutUsecase(this._repo);

  Future<void> call() {
    return _repo.signOut();
  }
}
