import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/commons/widgets/profile_widget.dart';
import '../../../core/constant/constants.dart';
import '../../cubit/post/cubit/post_cubit.dart';
import '../../cubit/user/cubit/user_cubit.dart';
import '../post/post_detail_page.dart';
import '../profile/other_user_profile_page.dart';
import 'widgets/search_widget.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({required this.currentUserUid, super.key});

  final String currentUserUid;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    context.read<UserCubit>().getAllUsers();
    context.read<PostCubit>().getPosts();
    super.initState();
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: backGroundColor,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: SearchWidget(controller: _searchController),
              ),
              _searchController.text.isNotEmpty
                  ? BlocBuilder<UserCubit, UserState>(
                      builder: (context, userState) {
                        if (userState is UsersLoaded) {
                          final filteredUsers = userState.users
                              .where((user) => user.username!
                                  .toLowerCase()
                                  .contains(
                                      _searchController.text.toLowerCase()))
                              .toList();
                          if (filteredUsers.isEmpty) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 300),
                              child: Center(
                                child: Text(
                                  'There is no user with that Username',
                                  style: themeData.textTheme.headlineLarge,
                                ),
                              ),
                            );
                          }
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: filteredUsers.length,
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 40,
                                      height: 40,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: profileWidget(
                                            imageUrl: filteredUsers[index]
                                                .profileUrl),
                                      ),
                                    ),
                                    sizeHor(10),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  OtherUserProfilePage(
                                                      currentUserUid:
                                                          widget.currentUserUid,
                                                      otherUserUid:
                                                          filteredUsers[index]
                                                              .uid!),
                                            ));
                                      },
                                      child: Text(
                                        "${filteredUsers[index].username}",
                                        style:
                                            themeData.textTheme.headlineLarge,
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    )
                  : const SizedBox.shrink(),
              sizeVer(10),
              _searchController.text.isEmpty
                  ? BlocBuilder<PostCubit, PostState>(
                      builder: (context, postState) {
                        if (postState is PostLoaded) {
                          final posts = postState.posts;
                          if (posts.isEmpty) {
                            return Center(
                              heightFactor: 30.0,
                              child: Text(
                                'There is no post to show.',
                                style: themeData.textTheme.headlineLarge,
                              ),
                            );
                          }
                          return GridView.builder(
                            itemCount: posts.length,
                            physics: const ScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 5,
                            ),
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            PostDetailPage(post: posts[index]),
                                      ));
                                },
                                child: SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: profileWidget(
                                      imageUrl: posts[index].postImageUrl),
                                ),
                              );
                            },
                          );
                        }
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
