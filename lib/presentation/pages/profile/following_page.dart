import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/user/user_entity.dart';

import '../../../core/commons/widgets/profile_widget.dart';
import '../../../core/constant/constants.dart';
import '../../cubit/user/cubit/user_cubit.dart';
import 'other_user_profile_page.dart';

class FollowingPage extends StatefulWidget {
  const FollowingPage({required this.user, super.key});

  final UserEntity user;

  @override
  State<FollowingPage> createState() => _FollowingPageState();
}

class _FollowingPageState extends State<FollowingPage> {
  @override
  void initState() {
    super.initState();
    context.read<UserCubit>().getAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Followings',
          style: themeData.textTheme.headlineLarge,
        ),
      ),
      body: SingleChildScrollView(
        child: BlocBuilder<UserCubit, UserState>(
          builder: (context, userState) {
            if (userState is UsersLoaded) {
              final filteredUsers = userState.users
                  .where(
                      (element) => widget.user.following!.contains(element.uid))
                  .toList();
              if (filteredUsers.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.only(top: 300),
                  child: Center(
                    child: Text(
                      'There is no followings to show.',
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
                                imageUrl: filteredUsers[index].profileUrl),
                          ),
                        ),
                        sizeHor(10),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OtherUserProfilePage(
                                      currentUserUid: widget.user.uid!,
                                      otherUserUid: filteredUsers[index].uid!),
                                ));
                          },
                          child: Text(
                            "${filteredUsers[index].username}",
                            style: themeData.textTheme.headlineLarge,
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
        ),
      ),
    );
  }
}
