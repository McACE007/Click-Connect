import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:click_connect_flutter_app/presentation/cubit/comment_page/cubit/comment_page_cubit.dart';
import '../../../../../domain/entities/reply/reply_entity.dart';
import '../../../../cubit/reply/cubit/reply_cubit.dart';
import '../../../../../domain/entities/post/post_entity.dart';
import 'package:uuid/uuid.dart';

import '../../../../../core/commons/widgets/profile_widget.dart';
import '../../../../../core/constant/constants.dart';
import '../../../../../domain/entities/comment/comment_entity.dart';
import '../../../../../domain/entities/user/user_entity.dart';
import '../../../../cubit/comment/cubit/comment_cubit.dart';

class CommentInputWidget extends StatefulWidget {
  const CommentInputWidget(
      {required this.post, required this.currentUser, super.key});

  final PostEntity post;
  final UserEntity currentUser;

  @override
  State<CommentInputWidget> createState() => _CommentInputWidgetState();
}

class _CommentInputWidgetState extends State<CommentInputWidget> {
  late TextEditingController _commentController;

  @override
  void initState() {
    _commentController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommentPageCubit, CommentPageState>(
      builder: (context, replyState) {
        if (replyState is CommentPageReplying) {
          return Container(
            width: double.infinity,
            height: 55,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 40,
                  height: 40,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child:
                        profileWidget(imageUrl: widget.currentUser.profileUrl),
                  ),
                ),
                sizeHor(10),
                Expanded(
                  child: TextFormField(
                    style: const TextStyle(color: primaryColor),
                    controller: _commentController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText:
                          "Add a comment for ${replyState.comment.username}...",
                      hintStyle: const TextStyle(color: secondaryColor),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => _submitReply(comment: replyState.comment),
                  child: const Text(
                    "Post",
                    style: TextStyle(fontSize: 15, color: blueColor),
                  ),
                ),
              ],
            ),
          );
        }
        return Container(
          width: double.infinity,
          height: 55,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 40,
                height: 40,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: profileWidget(imageUrl: widget.currentUser.profileUrl),
                ),
              ),
              sizeHor(10),
              Expanded(
                child: TextFormField(
                  style: const TextStyle(color: primaryColor),
                  controller: _commentController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Add a comment for ${widget.post.username}...",
                    hintStyle: const TextStyle(color: secondaryColor),
                  ),
                ),
              ),
              GestureDetector(
                onTap: _submitComment,
                child: const Text(
                  "Post",
                  style: TextStyle(fontSize: 15, color: blueColor),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  _submitComment() {
    context.read<CommentCubit>().createComment(
            comment: CommentEntity(
          commentId: const Uuid().v1(),
          postId: widget.post.postId,
          creatorUid: widget.currentUser.uid,
          description: _commentController.text,
          userProfileUrl: widget.currentUser.profileUrl,
          username: widget.currentUser.username,
          createAt: Timestamp.now(),
          likes: const [],
          totalReplays: 0,
        ));
    _commentController.clear();
  }

  _submitReply({required CommentEntity comment}) {
    context.read<ReplyCubit>().createReply(
            reply: ReplyEntity(
          replyId: const Uuid().v1(),
          commentId: comment.commentId,
          postId: comment.postId,
          creatorUid: widget.currentUser.uid,
          description: _commentController.text,
          userProfileUrl: widget.currentUser.profileUrl,
          username: widget.currentUser.username,
          createAt: Timestamp.now(),
          likes: const [],
        ));
    _commentController.clear();
  }
}
