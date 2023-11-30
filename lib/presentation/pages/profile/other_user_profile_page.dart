import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone_app/domain/entities/user/user_entity.dart';
import 'package:instagram_clone_app/presentation/cubit/user/cubit/user_cubit.dart';
import 'package:instagram_clone_app/presentation/widgets/button_container_widget.dart';

import '../../../core/commons/widgets/profile_widget.dart';
import '../../../core/constant/constants.dart';
import '../../cubit/post/cubit/post_cubit.dart';
import '../post/post_detail_page.dart';
import 'followers_page.dart';
import 'following_page.dart';

class OtherUserProfilePage extends StatefulWidget {
  const OtherUserProfilePage(
      {required this.currentUserUid, required this.otherUserUid, super.key});
  final String currentUserUid;
  final String otherUserUid;

  @override
  State<OtherUserProfilePage> createState() => _OtherUserProfilePageState();
}

class _OtherUserProfilePageState extends State<OtherUserProfilePage> {
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
          final currentUser = userState.users
              .where((user) => user.uid == widget.currentUserUid)
              .toList()[0];
          final otherUser = userState.users
              .where((user) => user.uid == widget.otherUserUid)
              .toList()[0];
          return Scaffold(
            appBar: AppBar(
              title: Text(
                "${otherUser.username}",
                style: themeData.textTheme.titleLarge,
              ),
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
                            child:
                                profileWidget(imageUrl: otherUser.profileUrl)),
                      ),
                      Row(
                        children: [
                          Column(
                            children: [
                              Text(
                                "${otherUser.totalPosts}",
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
                                  "${otherUser.totalFollowers}",
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
                                  "${otherUser.totalFollowing}",
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
                    "${otherUser.name == "" ? otherUser.username : otherUser.name}",
                    style: themeData.textTheme.headlineLarge,
                  ),
                  sizeVer(10),
                  Text(
                    "${otherUser.bio}",
                    style: themeData.textTheme.bodyLarge,
                  ),
                  sizeVer(10),
                  currentUser.uid != otherUser.uid
                      ? currentUser.following!.contains(otherUser.uid)
                          ? ButtonContainerWidget(
                              text: 'Unfollow',
                              color: darkGreyColor,
                              onTapListener: () {
                                context.read<UserCubit>().followUnfollowUser(
                                    user: UserEntity(
                                        otherUid: otherUser.uid,
                                        uid: currentUser.uid));
                                setState(() {});
                              },
                            )
                          : ButtonContainerWidget(
                              text: 'Follow',
                              color: blueColor,
                              onTapListener: () {
                                context.read<UserCubit>().followUnfollowUser(
                                    user: UserEntity(
                                        otherUid: otherUser.uid,
                                        uid: currentUser.uid));
                                setState(() {});
                              },
                            )
                      : const SizedBox.shrink(),
                  sizeVer(10),
                  BlocBuilder<PostCubit, PostState>(
                    builder: (context, postState) {
                      if (postState is PostLoaded) {
                        final posts = postState.posts
                            .where((post) => post.creatorUid == otherUser.uid)
                            .toList();
                        if (posts.isEmpty) {
                          return Center(
                            heightFactor: 25.0,
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
}
