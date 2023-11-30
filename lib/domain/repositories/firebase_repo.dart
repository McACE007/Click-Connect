import 'dart:io';

import '../../core/utils/typedefs.dart';
import '../entities/comment/comment_entity.dart';
import '../entities/post/post_entity.dart';
import '../entities/reply/reply_entity.dart';
import '../entities/user/user_entity.dart';

abstract class FirebaseRepo {
  // Credential Features
  ResultFuture<void> signInUser(UserEntity user);
  ResultFuture<void> signUpUser(UserEntity user);
  Future<bool> isSignIn();
  Future<void> signOut();

  // User Features
  Stream<List<UserEntity>> getAllUsers();
  Stream<List<UserEntity>> getSingleUser(String uid);
  Future<String> getCurrentUid();
  Future<void> createUserWithImage(UserEntity user, String profileUrl);
  Future<void> updateUser(UserEntity user);
  Future<void> followUnfollowUser(UserEntity user);

  // Cloud Storage Features
  Future<String> uploadImageToStorage(
      File? file, bool isPost, String childName);

  // Post Features
  ResultFuture<void> createPost(PostEntity post);
  Stream<List<PostEntity>> getPosts();
  ResultFuture<void> updatePost(PostEntity post);
  ResultFuture<void> deletePost(PostEntity post);
  ResultFuture<void> likePost(PostEntity post);

  // Comment Features
  ResultFuture<void> createComment(CommentEntity comment);
  ResultFuture<void> updateComment(CommentEntity comment);
  ResultFuture<void> deleteComment(CommentEntity comment);
  ResultFuture<void> likeComment(CommentEntity comment);
  Stream<List<CommentEntity>> getComments(String postId);

  // Relay Features
  ResultFuture<void> createReply(ReplyEntity reply);
  ResultFuture<void> deleteReply(ReplyEntity reply);
  ResultFuture<void> likeReply(ReplyEntity reply);
  Stream<List<ReplyEntity>> getReplys(ReplyEntity reply);
}
