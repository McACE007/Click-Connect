import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../core/commons/widgets/profile_widget.dart';
import '../../../../../core/constant/constants.dart';
import '../../../../../domain/entities/reply/reply_entity.dart';
import '../../../../cubit/reply/cubit/reply_cubit.dart';

class SingleReplyWidget extends StatefulWidget {
  const SingleReplyWidget({
    Key? key,
    required this.reply,
    required this.currentUid,
  }) : super(key: key);

  final ReplyEntity reply;
  final String currentUid;

  @override
  State<SingleReplyWidget> createState() => _SingleReplyWidgetState();
}

class _SingleReplyWidgetState extends State<SingleReplyWidget> {
  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      color: backGroundColor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: 30,
              height: 30,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: profileWidget(imageUrl: widget.reply.userProfileUrl),
              )),
          sizeHor(10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${widget.reply.username}",
                    style: themeData.textTheme.bodyLarge,
                  ),
                  sizeVer(3),
                  Text(
                    "${widget.reply.description}",
                    style: themeData.textTheme.bodyLarge,
                  ),
                  sizeVer(3),
                  Row(
                    children: [
                      Text(
                        DateFormat("dd/MMM/yyyy")
                            .format(widget.reply.createAt!.toDate()),
                        style: themeData.textTheme.bodySmall,
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
                    onTap: _likeReply,
                    child: Icon(
                      widget.reply.likes!.contains(widget.currentUid)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: widget.reply.likes!.contains(widget.currentUid)
                          ? Colors.red
                          : Colors.white,
                    ),
                  ),
                  sizeVer(4),
                  Text(
                    widget.reply.likes!.length.toString(),
                    style: themeData.textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  _likeReply() {
    context.read<ReplyCubit>().likeReply(reply: widget.reply);
  }
}
