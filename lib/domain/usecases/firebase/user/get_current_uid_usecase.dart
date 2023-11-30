import '../../../repositories/firebase_repo.dart';

class GetCurrentUidUsecase {
  final FirebaseRepo _repo;

  GetCurrentUidUsecase(this._repo);

  Future<String> call() {
    return _repo.getCurrentUid();
  }

  void then(Function(dynamic uid) param0) {}
}
