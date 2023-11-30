import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

import '../../../core/constant/constants.dart';
import '../../../core/errors/exception.dart';
import '../../../domain/entities/comment/comment_entity.dart';
import '../../../domain/entities/post/post_entity.dart';
import '../../../domain/entities/reply/reply_entity.dart';
import '../../../domain/entities/user/user_entity.dart';
import '../../models/comment/comment_model.dart';
import '../../models/post/post_model.dart';
import '../../models/reply/reply_model.dart';
import '../../models/user/user_model.dart';

abstract class RemoteDataSource {
  // Credential Features
  Future<void> signInUser(UserEntity user);
  Future<void> signUpUser(UserEntity user);
  Future<bool> isSignIn();
  Future<void> signOut();

  // User Features
  Stream<List<UserEntity>> getAllUsers();
  Stream<List<UserEntity>> getSingleUser(String uid);
  Future<String> getCurrentUid();
  Future<void> createUserWithImage(UserEntity user, String profileUrl);
  Future<void> updateUser(UserEntity user);
  Future<void> followUnfollowUser(UserEntity user);

  //Cloud Storage Features
  Future<String> uploadImageToStorage(
      File? file, bool isPost, String childName);

  // Post Features
  Future<void> createPost(PostEntity post);
  Future<void> updatePost(PostEntity post);
  Future<void> deletePost(PostEntity post);
  Future<void> likePost(PostEntity post);
  Stream<List<PostEntity>> getPosts();

  // Comment Features
  Future<void> createComment(CommentEntity comment);
  Future<void> updateComment(CommentEntity comment);
  Future<void> deleteComment(CommentEntity comment);
  Future<void> likeComment(CommentEntity comment);
  Stream<List<CommentEntity>> getComments(String postId);

  // Relay Features
  Future<void> createReply(ReplyEntity reply);
  Future<void> deleteReply(ReplyEntity reply);
  Future<void> likeReply(ReplyEntity reply);
  Stream<List<ReplyEntity>> getReplys(ReplyEntity reply);
}

class RemoteDataSourceImpl extends RemoteDataSource {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;
  final FirebaseStorage firebaseStorage;

  RemoteDataSourceImpl(
      this.firebaseFirestore, this.firebaseAuth, this.firebaseStorage);

  // Credential Features
  //////////////////////////////////////////////
  @override
  Future<void> signUpUser(UserEntity user) async {
    try {
      final currentUser = await firebaseAuth.createUserWithEmailAndPassword(
        email: user.email!,
        password: user.password!,
      );
      if (currentUser.user?.uid != null) {
        if (user.imageFile != null) {
          final profileUrl =
              await uploadImageToStorage(user.imageFile, false, 'profileImage');
          await createUserWithImage(user, profileUrl);
        } else {
          await createUserWithImage(user, '');
        }
      }
      return;
    } on FirebaseAuthException catch (e) {
      if (e.code == "email-already-in-use") {
        throw const AuthException('Email is already taken');
      } else {
        throw const AuthException('Something Went Wrong');
      }
    }
  }

  @override
  Future<void> signInUser(UserEntity user) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
        email: user.email!,
        password: user.password!,
      );
      return;
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        throw const AuthException('User not found');
      } else if (e.code == 'wrong-password') {
        throw const AuthException('Invalid email or password');
      } else {
        throw const AuthException('Something Went Wrong');
      }
    }
  }

  @override
  Future<bool> isSignIn() async => firebaseAuth.currentUser?.uid != null;

  @override
  Future<void> signOut() async => firebaseAuth.signOut();
  //////////////////////////////////////////////

  // User Features
  //////////////////////////////////////////////
  @override
  Stream<List<UserEntity>> getSingleUser(String uid) {
    final userCollection = firebaseFirestore
        .collection(FirebaseConstants.usersCollection)
        .where('uid', isEqualTo: uid)
        .limit(1);
    return userCollection.snapshots().map(
        (even) => even.docs.map((e) => UserModel.fromSnapshot(e)).toList());
  }

  @override
  Stream<List<UserEntity>> getAllUsers() {
    final userCollection =
        firebaseFirestore.collection(FirebaseConstants.usersCollection);
    return userCollection.snapshots().map(
        (even) => even.docs.map((e) => UserModel.fromSnapshot(e)).toList());
  }

  @override
  Future<String> getCurrentUid() async => firebaseAuth.currentUser!.uid;

  @override
  Future<void> createUserWithImage(UserEntity user, String profileUrl) async {
    final userCollection =
        firebaseFirestore.collection(FirebaseConstants.usersCollection);
    final uid = await getCurrentUid();
    userCollection.doc(uid).get().then((userDoc) {
      final newUser = UserModel(
        uid: uid,
        username: user.username,
        name: user.name,
        bio: user.bio,
        website: user.website,
        email: user.email,
        profileUrl: profileUrl,
        followers: user.followers,
        following: user.following,
        totalFollowers: user.totalFollowers,
        totalFollowing: user.totalFollowing,
        totalPosts: user.totalPosts,
      ).toJson();

      if (!userDoc.exists) {
        userCollection.doc(uid).set(newUser);
      } else {
        userCollection.doc(uid).update(newUser);
      }
    });
  }

  @override
  Future<void> updateUser(UserEntity user) async {
    final userCollection =
        firebaseFirestore.collection(FirebaseConstants.usersCollection);
    Map<String, dynamic> userInformation = {};

    if (user.username != "" && user.username != null) {
      userInformation['username'] = user.username;
    }

    if (user.website != "" && user.website != null) {
      userInformation['website'] = user.website;
    }

    if (user.profileUrl != "" && user.profileUrl != null) {
      userInformation['profileUrl'] = user.profileUrl;
    }

    if (user.bio != "" && user.bio != null) userInformation['bio'] = user.bio;

    if (user.name != "" && user.name != null) {
      userInformation['name'] = user.name;
    }

    if (user.totalFollowing != null) {
      userInformation['totalFollowing'] = user.totalFollowing;
    }

    if (user.totalFollowers != null) {
      userInformation['totalFollowers'] = user.totalFollowers;
    }

    if (user.totalPosts != null) {
      userInformation['totalPosts'] = user.totalPosts;
    }

    userCollection.doc(user.uid).update(userInformation);
  }

  @override
  Future<void> followUnfollowUser(UserEntity user) async {
    final usersCollection =
        firebaseFirestore.collection(FirebaseConstants.usersCollection);
    final myDocRef = await usersCollection.doc(user.uid).get();
    final otherDocRef = await usersCollection.doc(user.otherUid).get();

    if (myDocRef.exists && otherDocRef.exists) {
      List myFollowingList = myDocRef.get('following');

      final myTotalFollowing = myDocRef.get('totalFollowing');
      final otherTotalFollowers = otherDocRef.get('totalFollowers');

      // My Following List
      if (myFollowingList.contains(user.otherUid)) {
        await usersCollection.doc(user.uid).update({
          "following": FieldValue.arrayRemove([user.otherUid]),
          "totalFollowing": myTotalFollowing - 1,
        });
        usersCollection.doc(user.otherUid).update({
          "followers": FieldValue.arrayRemove([user.uid]),
          "totalFollowers": otherTotalFollowers - 1,
        });
      } else {
        await usersCollection.doc(user.uid).update({
          "following": FieldValue.arrayUnion([user.otherUid]),
          "totalFollowing": myTotalFollowing + 1,
        });
        usersCollection.doc(user.otherUid).update({
          "followers": FieldValue.arrayUnion([user.uid]),
          "totalFollowers": otherTotalFollowers + 1,
        });
      }
    }
  }
  //////////////////////////////////////////////

  // Cloud Storage Features
  //////////////////////////////////////////////
  @override
  Future<String> uploadImageToStorage(
      File? file, bool isPost, String childName) async {
    Reference ref = firebaseStorage
        .ref()
        .child(childName)
        .child(firebaseAuth.currentUser!.uid);
    if (isPost) {
      String id = const Uuid().v1();
      ref = ref.child(id);
    }
    final uploadTask = ref.putFile(file!);
    final imageUrl =
        (await uploadTask.whenComplete(() {})).ref.getDownloadURL();
    return await imageUrl;
  }
  //////////////////////////////////////////////

  // Post Features
  //////////////////////////////////////////////
  @override
  Future<void> createPost(PostEntity post) async {
    final postCollection =
        firebaseFirestore.collection(FirebaseConstants.postsCollection);
    final newPost = PostModel(
      postId: post.postId,
      creatorUid: post.creatorUid,
      username: post.username,
      decription: post.decription,
      postImageUrl: post.postImageUrl,
      likes: const [],
      totalLikes: 0,
      totalComments: 0,
      createAt: post.createAt,
      userProfileUrl: post.userProfileUrl,
    ).toJson();
    try {
      final postDocRef = await postCollection.doc(post.postId).get();
      if (!postDocRef.exists) {
        postCollection.doc(post.postId).set(newPost);
        final usersCollection = firebaseFirestore
            .collection(FirebaseConstants.usersCollection)
            .doc(post.creatorUid);
        final userDocRef = await usersCollection.get();
        if (userDocRef.exists) {
          final totalPosts = userDocRef.get('totalPosts');
          usersCollection.update({"totalPosts": totalPosts + 1});
          return;
        }
      } else {
        postCollection.doc(post.postId).update(newPost);
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> updatePost(PostEntity post) async {
    final postCollection =
        firebaseFirestore.collection(FirebaseConstants.postsCollection);
    Map<String, dynamic> postInfo = {};
    if (post.postImageUrl != "" && post.postImageUrl != null) {
      postInfo['postImageUrl'] = post.postImageUrl;
    }

    if (post.decription != "" && post.decription != null) {
      postInfo['decription'] = post.decription;
    }
    try {
      postCollection.doc(post.postId).update(postInfo);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> deletePost(PostEntity post) async {
    final postCollection =
        firebaseFirestore.collection(FirebaseConstants.postsCollection);
    try {
      await postCollection.doc(post.postId).delete();
      final usersCollection = firebaseFirestore
          .collection(FirebaseConstants.usersCollection)
          .doc(post.creatorUid);
      final userDocRef = await usersCollection.get();
      if (userDocRef.exists) {
        final totalPosts = userDocRef.get('totalPosts');
        usersCollection.update({"totalPosts": totalPosts - 1});
        return;
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> likePost(PostEntity post) async {
    final postCollection =
        firebaseFirestore.collection(FirebaseConstants.postsCollection);
    final uid = await getCurrentUid();
    try {
      final postDocRef = await postCollection.doc(post.postId).get();
      if (postDocRef.exists) {
        List likes = postDocRef.get("likes");
        final totalLikes = postDocRef.get("totalLikes");
        if (likes.contains(uid)) {
          postCollection.doc(post.postId).update({
            "likes": FieldValue.arrayRemove([uid]),
            "totalLikes": totalLikes - 1,
          });
        } else {
          postCollection.doc(post.postId).update({
            "likes": FieldValue.arrayUnion([uid]),
            "totalLikes": totalLikes + 1,
          });
        }
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Stream<List<PostEntity>> getPosts() {
    final postCollection = firebaseFirestore
        .collection(FirebaseConstants.postsCollection)
        .orderBy("createAt", descending: true);
    return postCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => PostModel.fromSnapshot(e)).toList());
  }
  //////////////////////////////////////////////

  // Comment Features
  //////////////////////////////////////////////
  @override
  Future<void> createComment(CommentEntity comment) async {
    final commentsCollection = firebaseFirestore
        .collection(FirebaseConstants.postsCollection)
        .doc(comment.postId)
        .collection(FirebaseConstants.commentsCollection);
    final newComment = CommentModel(
      commentId: comment.commentId,
      postId: comment.postId,
      creatorUid: comment.creatorUid,
      createAt: comment.createAt,
      description: comment.description,
      userProfileUrl: comment.userProfileUrl,
      username: comment.username,
      likes: const [],
      totalReplays: 0,
    ).toJson();
    try {
      final commentDocRef =
          await commentsCollection.doc(comment.commentId).get();
      if (!commentDocRef.exists) {
        await commentsCollection.doc(comment.commentId).set(newComment);
        final postsCollection = firebaseFirestore
            .collection(FirebaseConstants.postsCollection)
            .doc(comment.postId);
        postsCollection.get().then((postDocRef) {
          if (postDocRef.exists) {
            final totalComments = postDocRef.get('totalComments');
            postsCollection.update({"totalComments": totalComments + 1});
            return;
          }
        });
      } else {
        commentsCollection.doc(comment.commentId).update(newComment);
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> updateComment(CommentEntity comment) async {
    final commentsCollection = firebaseFirestore
        .collection(FirebaseConstants.postsCollection)
        .doc(comment.postId)
        .collection(FirebaseConstants.commentsCollection);
    Map<String, dynamic> commentInfo = {};

    if (comment.description != "" && comment.description != null) {
      commentInfo['description'] = comment.description;
    }
    try {
      commentsCollection.doc(comment.commentId).update(commentInfo);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> deleteComment(CommentEntity comment) async {
    final commentsCollection = firebaseFirestore
        .collection(FirebaseConstants.postsCollection)
        .doc(comment.postId)
        .collection(FirebaseConstants.commentsCollection);
    try {
      await commentsCollection.doc(comment.commentId).delete();
      final postsCollection = firebaseFirestore
          .collection(FirebaseConstants.postsCollection)
          .doc(comment.postId);
      postsCollection.get().then((postDocRef) {
        if (postDocRef.exists) {
          final totalComments = postDocRef.get('totalComments');
          postsCollection.update({"totalComments": totalComments - 1});
          return;
        }
      });
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> likeComment(CommentEntity comment) async {
    final commentsCollection = firebaseFirestore
        .collection(FirebaseConstants.postsCollection)
        .doc(comment.postId)
        .collection(FirebaseConstants.commentsCollection);
    final uid = await getCurrentUid();
    try {
      final commentDocRef =
          await commentsCollection.doc(comment.commentId).get();
      if (commentDocRef.exists) {
        List likes = commentDocRef.get("likes");
        if (likes.contains(uid)) {
          commentsCollection.doc(comment.commentId).update({
            "likes": FieldValue.arrayRemove([uid]),
          });
        } else {
          commentsCollection.doc(comment.commentId).update({
            "likes": FieldValue.arrayUnion([uid]),
          });
        }
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Stream<List<CommentEntity>> getComments(String postId) {
    final commentsCollection = firebaseFirestore
        .collection(FirebaseConstants.postsCollection)
        .doc(postId)
        .collection(FirebaseConstants.commentsCollection)
        .orderBy("createAt", descending: true);
    return commentsCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => CommentModel.fromSnapshot(e)).toList());
  }
  //////////////////////////////////////////////

  // Reply Features
  //////////////////////////////////////////////
  @override
  Future<void> createReply(ReplyEntity reply) async {
    final replysCollection = firebaseFirestore
        .collection(FirebaseConstants.postsCollection)
        .doc(reply.postId)
        .collection(FirebaseConstants.commentsCollection)
        .doc(reply.commentId)
        .collection(FirebaseConstants.replaysCollection);
    final newReply = ReplyModel(
      replyId: reply.replyId,
      commentId: reply.commentId,
      postId: reply.postId,
      creatorUid: reply.creatorUid,
      createAt: reply.createAt,
      description: reply.description,
      userProfileUrl: reply.userProfileUrl,
      username: reply.username,
      likes: const [],
    ).toJson();
    try {
      final replyDocRef = await replysCollection.doc(reply.replyId).get();
      if (!replyDocRef.exists) {
        await replysCollection.doc(reply.replyId).set(newReply);
        final commentsCollection = firebaseFirestore
            .collection(FirebaseConstants.postsCollection)
            .doc(reply.postId)
            .collection(FirebaseConstants.commentsCollection)
            .doc(reply.commentId);
        commentsCollection.get().then((commentDocRef) {
          if (commentDocRef.exists) {
            final totalReplys = commentDocRef.get('totalReplays');
            commentsCollection.update({"totalReplays": totalReplys + 1});
            return;
          }
        });
      } else {
        replysCollection.doc(reply.replyId).update(newReply);
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> deleteReply(ReplyEntity reply) async {
    final replysCollection = firebaseFirestore
        .collection(FirebaseConstants.postsCollection)
        .doc(reply.postId)
        .collection(FirebaseConstants.commentsCollection)
        .doc(reply.commentId)
        .collection(FirebaseConstants.replaysCollection);
    try {
      await replysCollection.doc(reply.replyId).delete();
      final commentsCollection = firebaseFirestore
          .collection(FirebaseConstants.postsCollection)
          .doc(reply.postId)
          .collection(FirebaseConstants.commentsCollection)
          .doc(reply.commentId);
      commentsCollection.get().then((commentDocRef) {
        if (commentDocRef.exists) {
          final totalReplys = commentDocRef.get('totalReplays');
          commentsCollection.update({"totalReplays": totalReplys - 1});
          return;
        }
      });
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> likeReply(ReplyEntity reply) async {
    final replysCollection = firebaseFirestore
        .collection(FirebaseConstants.postsCollection)
        .doc(reply.postId)
        .collection(FirebaseConstants.commentsCollection)
        .doc(reply.commentId)
        .collection(FirebaseConstants.replaysCollection);
    final uid = await getCurrentUid();
    try {
      final replyDocRef = await replysCollection.doc(reply.replyId).get();
      if (replyDocRef.exists) {
        List likes = replyDocRef.get("likes");
        if (likes.contains(uid)) {
          replysCollection.doc(reply.replyId).update({
            "likes": FieldValue.arrayRemove([uid]),
          });
        } else {
          replysCollection.doc(reply.replyId).update({
            "likes": FieldValue.arrayUnion([uid]),
          });
        }
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Stream<List<ReplyEntity>> getReplys(ReplyEntity reply) {
    final replysCollection = firebaseFirestore
        .collection(FirebaseConstants.postsCollection)
        .doc(reply.postId)
        .collection(FirebaseConstants.commentsCollection)
        .doc(reply.commentId)
        .collection(FirebaseConstants.replaysCollection)
        .orderBy("createAt", descending: true);
    return replysCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => ReplyModel.fromSnapshot(e)).toList());
  }
  //////////////////////////////////////////////
}
