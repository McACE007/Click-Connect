import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:click_connect_flutter_app/domain/entities/post/post_entity.dart';
import 'package:click_connect_flutter_app/presentation/cubit/post/cubit/post_cubit.dart';

import '../home/widgets/single_post_widget.dart';

class PostDetailPage extends StatefulWidget {
  const PostDetailPage({required this.post, super.key});

  final PostEntity post;

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Post Detail',
          style: themeData.textTheme.titleLarge,
        ),
      ),
      body: BlocBuilder<PostCubit, PostState>(
        builder: (context, postState) {
          if (postState is PostLoaded) {
            final post = postState.posts.where(
              (post) {
                return post.postId == widget.post.postId;
              },
            ).toList();
            return SinglePostWidget(
              post: post[0],
              exitPostDetailPage: _exitPostDetailPage,
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  _exitPostDetailPage() {
    Navigator.pop(context);
  }
}
