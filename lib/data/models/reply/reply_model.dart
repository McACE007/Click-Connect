import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/entities/reply/reply_entity.dart';

class ReplyModel extends ReplyEntity {
  const ReplyModel({
    super.replyId,
    super.commentId,
    super.postId,
    super.creatorUid,
    super.description,
    super.username,
    super.userProfileUrl,
    super.createAt,
    super.likes,
  });

  factory ReplyModel.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return ReplyModel(
      replyId: snapshot["replyId"],
      commentId: snapshot["commentId"],
      postId: snapshot["postId"],
      creatorUid: snapshot["creatorUid"],
      username: snapshot["username"],
      description: snapshot["description"],
      likes: List.from(snap.get("likes")),
      createAt: snapshot["createAt"],
      userProfileUrl: snapshot["userProfileUrl"],
    );
  }

  Map<String, dynamic> toJson() => {
        "replyId": replyId,
        "commentId": commentId,
        "postId": postId,
        "creatorUid": creatorUid,
        "description": description,
        "username": username,
        "likes": likes,
        "createAt": createAt,
        "userProfileUrl": userProfileUrl,
      };
}
