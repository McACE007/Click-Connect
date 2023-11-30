// ignore_for_file: overridden_fields, annotate_overrides

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/entities/user/user_entity.dart';

class UserModel extends UserEntity {
  final String? uid;
  final String? username;
  final String? name;
  final String? bio;
  final String? website;
  final String? email;
  final String? profileUrl;
  final List? followers;
  final List? following;
  final num? totalFollowers;
  final num? totalFollowing;
  final num? totalPosts;

  const UserModel({
    this.uid,
    this.username,
    this.name,
    this.bio,
    this.website,
    this.email,
    this.profileUrl,
    this.followers,
    this.following,
    this.totalFollowers,
    this.totalFollowing,
    this.totalPosts,
  }) : super(
          totalPosts: totalPosts,
          uid: uid,
          bio: bio,
          email: email,
          followers: followers,
          following: following,
          name: name,
          username: username,
          website: website,
          profileUrl: profileUrl,
          totalFollowers: totalFollowers,
          totalFollowing: totalFollowing,
        );

  factory UserModel.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return UserModel(
      totalPosts: snapshot["totalPosts"],
      uid: snapshot["uid"],
      bio: snapshot["bio"],
      email: snapshot["email"],
      followers: List.from(snap.get("followers")),
      following: List.from(snap.get("following")),
      name: snapshot["name"],
      username: snapshot["username"],
      website: snapshot["website"],
      profileUrl: snapshot["profileUrl"],
      totalFollowers: snapshot["totalFollowers"],
      totalFollowing: snapshot["totalFollowing"],
    );
  }

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "email": email,
        "name": name,
        "username": username,
        "totalFollowers": totalFollowers,
        "totalFollowing": totalFollowing,
        "totalPosts": totalPosts,
        "website": website,
        "bio": bio,
        "profileUrl": profileUrl,
        "followers": followers,
        "following": following,
      };
}
