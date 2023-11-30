import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../core/errors/exception.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/typedefs.dart';
import '../../domain/entities/comment/comment_entity.dart';
import '../../domain/entities/post/post_entity.dart';
import '../../domain/entities/reply/reply_entity.dart';
import '../../domain/entities/user/user_entity.dart';
import '../../domain/repositories/firebase_repo.dart';
import '../data_sources/remore_data_sources/remote_data_source.dart';

class FirebaseRepoImpl extends FirebaseRepo {
  final RemoteDataSource remoteDataSource;

  FirebaseRepoImpl(this.remoteDataSource);

  // Credential Features
  //////////////////////////////////////////////
  @override
  ResultFuture<void> signUpUser(UserEntity user) async {
    try {
      await remoteDataSource.signUpUser(user);
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure.fromException(e));
    }
  }

  @override
  ResultFuture<void> signInUser(UserEntity user) async {
    try {
      await remoteDataSource.signInUser(user);
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure.fromException(e));
    }
  }

  @override
  Future<bool> isSignIn() async => remoteDataSource.isSignIn();

  @override
  Future<void> signOut() async => remoteDataSource.signOut();
  //////////////////////////////////////////////

  // User Features
  //////////////////////////////////////////////
  @override
  Stream<List<UserEntity>> getSingleUser(String uid) =>
      remoteDataSource.getSingleUser(uid);

  @override
  Stream<List<UserEntity>> getAllUsers() => remoteDataSource.getAllUsers();

  @override
  Future<String> getCurrentUid() async => remoteDataSource.getCurrentUid();

  @override
  Future<void> createUserWithImage(UserEntity user, String profileUrl) async =>
      remoteDataSource.createUserWithImage(user, profileUrl);

  @override
  Future<void> updateUser(UserEntity user) async =>
      remoteDataSource.updateUser(user);

  @override
  Future<void> followUnfollowUser(UserEntity user) async =>
      remoteDataSource.followUnfollowUser(user);
  //////////////////////////////////////////////

  // Cloud Storage Features
  //////////////////////////////////////////////
  @override
  Future<String> uploadImageToStorage(
          File? file, bool isPost, String childName) async =>
      remoteDataSource.uploadImageToStorage(file, isPost, childName);
  //////////////////////////////////////////////

  // Post Features
  //////////////////////////////////////////////
  @override
  ResultFuture<void> createPost(PostEntity post) async {
    try {
      await remoteDataSource.createPost(post);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<void> updatePost(PostEntity post) async {
    try {
      await remoteDataSource.updatePost(post);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<void> deletePost(PostEntity post) async {
    try {
      await remoteDataSource.deletePost(post);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<void> likePost(PostEntity post) async {
    try {
      await remoteDataSource.likePost(post);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  Stream<List<PostEntity>> getPosts() => remoteDataSource.getPosts();
  //////////////////////////////////////////////

  // Comment Features
  //////////////////////////////////////////////
  @override
  ResultFuture<void> createComment(CommentEntity comment) async {
    try {
      await remoteDataSource.createComment(comment);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<void> updateComment(CommentEntity comment) async {
    try {
      await remoteDataSource.updateComment(comment);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<void> deleteComment(CommentEntity comment) async {
    try {
      await remoteDataSource.deleteComment(comment);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<void> likeComment(CommentEntity comment) async {
    try {
      await remoteDataSource.likeComment(comment);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  Stream<List<CommentEntity>> getComments(String postId) =>
      remoteDataSource.getComments(postId);
  //////////////////////////////////////////////

  // Reply Features
  //////////////////////////////////////////////
  @override
  ResultFuture<void> createReply(ReplyEntity reply) async {
    try {
      await remoteDataSource.createReply(reply);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<void> deleteReply(ReplyEntity reply) async {
    try {
      await remoteDataSource.deleteReply(reply);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<void> likeReply(ReplyEntity reply) async {
    try {
      await remoteDataSource.likeReply(reply);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  Stream<List<ReplyEntity>> getReplys(ReplyEntity reply) =>
      remoteDataSource.getReplys(reply);
  //////////////////////////////////////////////
}
