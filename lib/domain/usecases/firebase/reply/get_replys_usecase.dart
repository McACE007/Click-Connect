import '../../../entities/reply/reply_entity.dart';

import '../../../repositories/firebase_repo.dart';

class GetReplysUsecase {
  final FirebaseRepo _repo;

  GetReplysUsecase(this._repo);

  Stream<List<ReplyEntity>> call(ReplyEntity reply) => _repo.getReplys(reply);
}
