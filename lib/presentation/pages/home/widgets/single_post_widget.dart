import 'dart:async';

import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/commons/widgets/profile_widget.dart';
import '../../../../core/constant/constants.dart';
import '../../../../domain/entities/comment/comment_entity.dart';
import '../../../../domain/entities/post/post_entity.dart';
import '../../../../domain/entities/reply/reply_entity.dart';
import '../../../../domain/entities/user/user_entity.dart';
import '../../../../domain/usecases/firebase/user/get_current_uid_usecase.dart';
import '../../../../injection_container.dart' as di;
import '../../../cubit/comment/cubit/comment_cubit.dart';
import '../../../cubit/post/cubit/post_cubit.dart';
import '../../../cubit/reply/cubit/reply_cubit.dart';
import '../../../cubit/user/cubit/user_cubit.dart';
import '../../post/comment/widgets/Single_reply_widget.dart';
import '../../post/comment/widgets/comment_input_widget.dart';
import '../../post/comment/widgets/single_comment_widget.dart';
import '../../post/update_post_page.dart';
import '../../post/widgets/like_animation_widget.dart';
import '../../profile/other_user_profile_page.dart';

class SinglePostWidget extends StatefulWidget {
  const SinglePostWidget(
      {required this.post, this.exitPostDetailPage, super.key});

  final PostEntity post;
  final VoidCallback? exitPostDetailPage;

  @override
  State<SinglePostWidget> createState() => _SinglePostWidgetState();
}

class _SinglePostWidgetState extends State<SinglePostWidget> {
  bool _isLikeAnimating = false;
  String? _uid;
  bool isUserReplaying = false;

  @override
  void initState() {
    di.sl<GetCurrentUidUsecase>().call().then((uid) {
      setState(() {
        _uid = uid;
      });
      context.read<UserCubit>().getAllUsers();
    });
    context.read<CommentCubit>().getComments(widget.post.postId!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child:
                          profileWidget(imageUrl: widget.post.userProfileUrl),
                    ),
                  ),
                  sizeHor(10),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OtherUserProfilePage(
                                currentUserUid: _uid!,
                                otherUserUid: widget.post.creatorUid!),
                          ));
                    },
                    child: Text(
                      "${widget.post.username}",
                      style: themeData.textTheme.headlineLarge,
                    ),
                  )
                ],
              ),
              widget.post.creatorUid == _uid
                  ? GestureDetector(
                      onTap: () => _openBottomModalSheet(context, themeData),
                      child: const Icon(
                        Icons.more_vert,
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
        GestureDetector(
          onDoubleTap: () async {
            await _likePost();
            setState(() {
              _isLikeAnimating = true;
            });
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.30,
                child: profileWidget(imageUrl: widget.post.postImageUrl),
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: _isLikeAnimating ? 1 : 0,
                child: LikeAnimationWidget(
                  duration: const Duration(milliseconds: 300),
                  isLikeAnimating: _isLikeAnimating,
                  onLikeFinish: () {
                    setState(() {
                      _isLikeAnimating = false;
                    });
                  },
                  child: const Icon(
                    Icons.favorite,
                    color: Colors.white,
                    size: 100,
                  ),
                ),
              ),
            ],
          ),
        ),
        sizeVer(10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  _likePost();
                },
                child: Icon(
                  widget.post.likes!.contains(_uid)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: widget.post.likes!.contains(_uid)
                      ? Colors.red
                      : Colors.white,
                ),
              ),
              const Spacer(
                flex: 20,
              ),
              GestureDetector(
                onTap: () {},
                child: const Icon(
                  Icons.bookmark_outline,
                ),
              ),
              const Spacer(
                flex: 1,
              ),
              GestureDetector(
                onTap: () => _openCommentBottomModalSheet(context, themeData),
                child: const Icon(
                  FeatherIcons.messageCircle,
                ),
              ),
              const Spacer(
                flex: 1,
              ),
              GestureDetector(
                onTap: () {},
                child: const Icon(
                  FeatherIcons.send,
                ),
              ),
            ],
          ),
        ),
        sizeVer(10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${widget.post.totalLikes} likes",
                style: themeData.textTheme.headlineLarge,
              ),
              sizeVer(10),
              Row(
                children: [
                  Text(
                    "${widget.post.username}",
                    style: themeData.textTheme.headlineLarge,
                  ),
                  sizeHor(10),
                  Text(
                    "${widget.post.decription}",
                    style: themeData.textTheme.bodyLarge,
                  ),
                ],
              ),
              sizeVer(10),
              Text(
                "View all ${widget.post.totalComments} comments",
                style: themeData.textTheme.bodyMedium,
              ),
              sizeVer(10),
              Text(
                DateFormat("dd/MMM/yyyy")
                    .format(widget.post.createAt!.toDate()),
                style: themeData.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }

  _likePost() {
    context
        .read<PostCubit>()
        .likePost(post: PostEntity(postId: widget.post.postId));
  }

  _openBottomModalSheet(BuildContext context, ThemeData themeData) {
    return showModalBottomSheet(
        showDragHandle: true,
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              UpdatePostPage(post: widget.post),
                        ));
                  },
                  child: Container(
                    padding: const EdgeInsets.only(left: 20),
                    height: 40,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.movie_edit,
                        ),
                        sizeHor(10),
                        Text(
                          "Edit Post",
                          style: themeData.textTheme.headlineLarge,
                        )
                      ],
                    ),
                  ),
                ),
                sizeVer(15),
                InkWell(
                  onTap: () async {
                    Navigator.pop(context);
                    await _deletePost();
                    if (widget.exitPostDetailPage != null) {
                      widget.exitPostDetailPage!();
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.only(left: 20),
                    height: 40,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.highlight_remove,
                        ),
                        sizeHor(10),
                        Text(
                          "Delete Post",
                          style: themeData.textTheme.headlineLarge,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  _openCommentBottomModalSheet(BuildContext context, ThemeData themeData) {
    return showModalBottomSheet(
        showDragHandle: true,
        context: context,
        isScrollControlled: true,
        builder: (context) {
          List<CommentEntity> selectedComments = [];
          StreamController<int> controller = StreamController();
          StreamController<int> controller1 = StreamController();
          return Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            height: 500,
            child: Column(
              children: [
                StreamBuilder<int>(
                  stream: controller1.stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data! > 0) {
                      return Container(
                        width: double.infinity,
                        height: 60,
                        color: blueColor,
                        padding: const EdgeInsets.only(right: 15, left: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${snapshot.data} selected',
                              style: themeData.textTheme.titleLarge,
                            ),
                            GestureDetector(
                              onTap: () async {
                                await _deleteComment(selectedComments);
                                selectedComments.clear();
                                controller.add(0);
                                controller1.add(0);
                              },
                              child: const Icon(
                                Icons.delete_outlined,
                                size: 35,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        'Comments',
                        style: themeData.textTheme.titleLarge,
                      ),
                    );
                  },
                ),
                BlocBuilder<CommentCubit, CommentState>(
                  builder: (context, commentState) {
                    if (commentState is CommentLoaded) {
                      String clickedCommentId = '';
                      final comments = commentState.comments;
                      return comments.isEmpty
                          ? Expanded(
                              child: Center(
                                child: Text(
                                  'No comments yet!',
                                  style: themeData.textTheme.bodyLarge,
                                ),
                              ),
                            )
                          : StreamBuilder<int>(
                              stream: controller.stream,
                              builder: (context, snapshot) {
                                return Expanded(
                                  child: ListView.builder(
                                    itemCount: comments.length,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              if (comments[index].creatorUid ==
                                                  _uid) {
                                                if (selectedComments.contains(
                                                    comments[index])) {
                                                  selectedComments
                                                      .remove(comments[index]);
                                                } else {
                                                  selectedComments
                                                      .add(comments[index]);
                                                }
                                                controller.add(
                                                    selectedComments.length);
                                                controller1.add(
                                                    selectedComments.length);
                                              }
                                            },
                                            child: SingleCommentWidget(
                                              comment: comments[index],
                                              selectedComments:
                                                  selectedComments,
                                              currentUid: _uid!,
                                            ),
                                          ),
                                          comments[index].totalReplays! > 0 &&
                                                  (clickedCommentId.isEmpty ||
                                                      clickedCommentId !=
                                                          comments[index]
                                                              .commentId)
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 50),
                                                  child: Row(
                                                    children: [
                                                      sizeHor(15),
                                                      const SizedBox(
                                                        width: 15,
                                                        child: Divider(
                                                          color: darkGreyColor,
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () async {
                                                          await context
                                                              .read<
                                                                  ReplyCubit>()
                                                              .getReplys(
                                                                reply:
                                                                    ReplyEntity(
                                                                  postId: comments[
                                                                          index]
                                                                      .postId,
                                                                  commentId: comments[
                                                                          index]
                                                                      .commentId,
                                                                ),
                                                              );
                                                          clickedCommentId =
                                                              comments[index]
                                                                  .commentId!;
                                                          controller.add(-1);
                                                        },
                                                        child: Text(
                                                          " View ${comments[index].totalReplays} Replays",
                                                          style: themeData
                                                              .textTheme
                                                              .bodySmall,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : const SizedBox.shrink(),
                                          comments[index].commentId ==
                                                  clickedCommentId
                                              ? BlocBuilder<ReplyCubit,
                                                  ReplyState>(
                                                  builder: (context, state) {
                                                    if (state is ReplyLoaded) {
                                                      final replys =
                                                          state.replys;
                                                      if (replys[0].commentId ==
                                                          comments[index]
                                                              .commentId) {
                                                        return ListView.builder(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 56),
                                                          shrinkWrap: true,
                                                          physics:
                                                              const ScrollPhysics(),
                                                          itemCount:
                                                              replys.length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            return SingleReplyWidget(
                                                              reply:
                                                                  replys[index],
                                                              currentUid: _uid!,
                                                            );
                                                          },
                                                        );
                                                      }
                                                    } else if (state
                                                        is ReplyLoading) {
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 50),
                                                        child: Row(
                                                          children: [
                                                            sizeHor(15),
                                                            const SizedBox(
                                                              width: 15,
                                                              child: Divider(
                                                                color:
                                                                    darkGreyColor,
                                                              ),
                                                            ),
                                                            Text(
                                                              " Loading...",
                                                              style: themeData
                                                                  .textTheme
                                                                  .bodySmall,
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    }
                                                    return const SizedBox
                                                        .shrink();
                                                  },
                                                )
                                              : const SizedBox.shrink(),
                                        ],
                                      );
                                    },
                                  ),
                                );
                              });
                    }
                    return const Expanded(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  },
                ),
                BlocBuilder<UserCubit, UserState>(
                  builder: (context, userState) {
                    if (userState is UsersLoaded) {
                      final user = userState.users
                          .where(
                            (user) => user.uid == _uid,
                          )
                          .toList()[0];
                      return CommentInputWidget(
                        post: widget.post,
                        currentUser: user,
                      );
                    }
                    return CommentInputWidget(
                      post: widget.post,
                      currentUser: const UserEntity(),
                    );
                  },
                ),
              ],
            ),
          );
        });
  }

  _deleteComment(List<CommentEntity> selectedComments) async {
    for (CommentEntity comment in selectedComments) {
      await context.read<CommentCubit>().deleteComment(comment: comment);
    }
  }

  _deletePost() {
    context.read<PostCubit>().deletePost(post: widget.post);
  }
}
