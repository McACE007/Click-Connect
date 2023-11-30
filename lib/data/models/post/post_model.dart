import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/entities/post/post_entity.dart';

class PostModel extends PostEntity {
  const PostModel({
    required super.postId,
    required super.creatorUid,
    required super.username,
    required super.decription,
    required super.postImageUrl,
    required super.likes,
    required super.totalLikes,
    required super.totalComments,
    required super.createAt,
    required super.userProfileUrl,
  });

  factory PostModel.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return PostModel(
      postId: snapshot["postId"],
      creatorUid: snapshot["creatorUid"],
      username: snapshot["username"],
      decription: snapshot["decription"],
      likes: List.from(snap.get("likes")),
      totalLikes: snapshot["totalLikes"],
      totalComments: snapshot["totalComments"],
      createAt: snapshot["createAt"],
      userProfileUrl: snapshot["userProfileUrl"],
      postImageUrl: snapshot["postImageUrl"],
    );
  }
  Map<String, dynamic> toJson() => {
        "postId": postId,
        "creatorUid": creatorUid,
        "decription": decription,
        "username": username,
        "likes": likes,
        "totalLikes": totalLikes,
        "totalComments": totalComments,
        "createAt": createAt,
        "userProfileUrl": userProfileUrl,
        "postImageUrl": postImageUrl,
      };
}
