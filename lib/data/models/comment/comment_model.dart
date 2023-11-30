import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/entities/comment/comment_entity.dart';

class CommentModel extends CommentEntity {
  const CommentModel({
    super.commentId,
    super.postId,
    super.creatorUid,
    super.description,
    super.username,
    super.userProfileUrl,
    super.createAt,
    super.likes,
    super.totalReplays,
  });

  factory CommentModel.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return CommentModel(
      commentId: snapshot["commentId"],
      postId: snapshot["postId"],
      creatorUid: snapshot["creatorUid"],
      username: snapshot["username"],
      description: snapshot["description"],
      likes: List.from(snap.get("likes")),
      createAt: snapshot["createAt"],
      userProfileUrl: snapshot["userProfileUrl"],
      totalReplays: snapshot["totalReplays"],
    );
  }

  Map<String, dynamic> toJson() => {
        "commentId": commentId,
        "postId": postId,
        "creatorUid": creatorUid,
        "description": description,
        "username": username,
        "likes": likes,
        "createAt": createAt,
        "userProfileUrl": userProfileUrl,
        "totalReplays": totalReplays,
      };
}
