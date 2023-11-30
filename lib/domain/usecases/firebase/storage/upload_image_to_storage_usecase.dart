import 'dart:io';

import '../../../repositories/firebase_repo.dart';

class UploadImageToStorageUsecase {
  final FirebaseRepo _repo;

  UploadImageToStorageUsecase(this._repo);

  Future<String> call(File? file, bool isPost, String childName) {
    return _repo.uploadImageToStorage(file, isPost, childName);
  }
}
