import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:instagram_clone_app/presentation/cubit/post/cubit/post_cubit.dart';
import 'package:instagram_clone_app/presentation/cubit/user/cubit/user_cubit.dart';
import 'package:instagram_clone_app/presentation/pages/profile/followers_page.dart';
import 'package:instagram_clone_app/presentation/pages/profile/following_page.dart';

import '../../../core/commons/widgets/profile_widget.dart';
import '../../../core/constant/constants.dart';
import '../../../domain/entities/user/user_entity.dart';
import '../../cubit/auth/cubit/auth_cubit.dart';
import '../post/post_detail_page.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({required this.currentUserUid, super.key});

  final String currentUserUid;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    context.read<UserCubit>().getAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, userState) {
        if (userState is UsersLoaded) {
          final UserEntity currentUser = userState.users
              .where(
                (user) => user.uid == widget.currentUserUid,
              )
              .toList()[0];
          return Scaffold(
            appBar: AppBar(
              title: Text(
                "${currentUser.username}",
                style: themeData.textTheme.titleLarge,
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: IconButton(
                    icon: const Icon(
                      Icons.menu,
                      color: primaryColor,
                    ),
                    onPressed: () =>
                        _openBottomModalSheet(context, themeData, currentUser),
                  ),
                )
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 80,
                        height: 80,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(40),
                            child: profileWidget(
                                imageUrl: currentUser.profileUrl)),
                      ),
                      Row(
                        children: [
                          Column(
                            children: [
                              Text(
                                "${currentUser.totalPosts}",
                                style: themeData.textTheme.bodyLarge,
                              ),
                              sizeVer(8),
                              Text(
                                "Posts",
                                style: themeData.textTheme.bodyLarge,
                              ),
                            ],
                          ),
                          sizeHor(25),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        FollowersPage(user: currentUser),
                                  ));
                            },
                            child: Column(
                              children: [
                                Text(
                                  "${currentUser.totalFollowers}",
                                  style: themeData.textTheme.bodyLarge,
                                ),
                                sizeVer(8),
                                Text(
                                  "Followers",
                                  style: themeData.textTheme.bodyLarge,
                                ),
                              ],
                            ),
                          ),
                          sizeHor(25),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        FollowingPage(user: currentUser),
                                  ));
                            },
                            child: Column(
                              children: [
                                Text(
                                  "${currentUser.totalFollowing}",
                                  style: themeData.textTheme.bodyLarge,
                                ),
                                sizeVer(8),
                                Text(
                                  "Following",
                                  style: themeData.textTheme.bodyLarge,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  sizeVer(10),
                  Text(
                    "${currentUser.name == "" ? currentUser.username : currentUser.name}",
                    style: themeData.textTheme.headlineLarge,
                  ),
                  sizeVer(10),
                  Text(
                    "${currentUser.bio}",
                    style: themeData.textTheme.bodyLarge,
                  ),
                  sizeVer(10),
                  BlocBuilder<PostCubit, PostState>(
                    builder: (context, postState) {
                      if (postState is PostLoaded) {
                        final posts = postState.posts
                            .where((post) => post.creatorUid == currentUser.uid)
                            .toList();
                        if (posts.isEmpty) {
                          return Center(
                            heightFactor: 20.0,
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
                  ),
                ],
              ),
            ),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  _openBottomModalSheet(
      BuildContext context, ThemeData themeData, UserEntity user) {
    return showModalBottomSheet(
      showDragHandle: true,
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfilePage(user: user),
                    )),
                child: Container(
                  padding: const EdgeInsets.only(left: 20),
                  height: 40,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.edit,
                      ),
                      sizeHor(10),
                      Text(
                        "Edit Profile",
                        style: themeData.textTheme.headlineLarge,
                      )
                    ],
                  ),
                ),
              ),
              sizeVer(15),
              InkWell(
                onTap: () async {
                  context.pop();
                  await context.read<AuthCubit>().loggedOut();
                },
                child: Container(
                  padding: const EdgeInsets.only(left: 20),
                  height: 40,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.logout,
                      ),
                      sizeHor(10),
                      Text(
                        "Log Out",
                        style: themeData.textTheme.headlineLarge,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
