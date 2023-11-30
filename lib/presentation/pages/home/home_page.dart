import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../cubit/post/cubit/post_cubit.dart';
import 'widgets/single_post_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<PostCubit>().getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: SvgPicture.asset(
            "assets/Logo.svg",
            height: 35,
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Icon(
                MdiIcons.facebookMessenger,
              ),
            ),
          ]),
      body: BlocBuilder<PostCubit, PostState>(
        builder: (context, postState) {
          if (postState is PostLoaded) {
            final posts = postState.posts;
            return posts.isEmpty
                ? const Center(
                    child: Text(
                      'There is no post yet.',
                    ),
                  )
                : ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      return SinglePostWidget(post: posts[index]);
                    },
                  );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
