import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../core/commons/widgets/profile_widget.dart';
import '../../../../../core/constant/constants.dart';
import '../../../../../domain/entities/comment/comment_entity.dart';
import '../../../../cubit/comment/cubit/comment_cubit.dart';
import '../../../../cubit/comment_page/cubit/comment_page_cubit.dart';

class SingleCommentWidget extends StatefulWidget {
  const SingleCommentWidget({
    Key? key,
    required this.comment,
    required this.selectedComments,
    required this.currentUid,
  }) : super(key: key);

  final CommentEntity comment;
  final List<CommentEntity> selectedComments;
  final String currentUid;

  @override
  State<SingleCommentWidget> createState() => _SingleCommentWidgetState();
}

class _SingleCommentWidgetState extends State<SingleCommentWidget> {
  bool _isFirstTime = true;
  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          color: widget.selectedComments.contains(widget.comment)
              ? Colors.grey[800]
              : backGroundColor,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  width: 40,
                  height: 40,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child:
                        profileWidget(imageUrl: widget.comment.userProfileUrl),
                  )),
              sizeHor(10),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${widget.comment.username}",
                          style: themeData.textTheme.bodyLarge,
                        ),
                        sizeVer(4),
                        Text(
                          "${widget.comment.description}",
                          style: themeData.textTheme.bodyLarge,
                        ),
                        sizeVer(4),
                        Row(
                          children: [
                            Text(
                              DateFormat("dd/MMM/yyyy")
                                  .format(widget.comment.createAt!.toDate()),
                              style: themeData.textTheme.bodySmall,
                            ),
                            sizeHor(15),
                            GestureDetector(
                              child: Text(
                                "Replay",
                                style: themeData.textTheme.bodySmall,
                              ),
                              onTap: () {
                                if (_isFirstTime) {
                                  context
                                      .read<CommentPageCubit>()
                                      .isReplying(comment: widget.comment);
                                  _isFirstTime = false;
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    sizeHor(150),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: _likeComment,
                          child: Icon(
                            widget.comment.likes!.contains(widget.currentUid)
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: widget.comment.likes!
                                    .contains(widget.currentUid)
                                ? Colors.red
                                : Colors.white,
                          ),
                        ),
                        sizeVer(4),
                        Text(
                          widget.comment.likes!.length.toString(),
                          style: themeData.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  _likeComment() {
    context.read<CommentCubit>().likeComment(comment: widget.comment);
  }
}
