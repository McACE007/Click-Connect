import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ReplyEntity extends Equatable {
  final String? replyId;
  final String? commentId;
  final String? postId;
  final String? creatorUid;
  final String? description;
  final String? username;
  final String? userProfileUrl;
  final Timestamp? createAt;
  final List<String>? likes;

  const ReplyEntity({
    this.replyId,
    this.commentId,
    this.postId,
    this.creatorUid,
    this.description,
    this.username,
    this.userProfileUrl,
    this.createAt,
    this.likes,
  });

  @override
  List<Object?> get props => [
        replyId,
        commentId,
        postId,
        creatorUid,
        description,
        username,
        userProfileUrl,
        createAt,
        likes,
      ];
}
