import '../../../../core/usercases/usercases.dart';
import '../../../../core/utils/typedefs.dart';
import '../../../entities/reply/reply_entity.dart';
import '../../../repositories/firebase_repo.dart';

class CreateReplyUsecase extends UsecaseWithParams<void, ReplyEntity> {
  const CreateReplyUsecase(this._repo);
  final FirebaseRepo _repo;

  @override
  ResultFuture call(params) => _repo.createReply(params);
}
