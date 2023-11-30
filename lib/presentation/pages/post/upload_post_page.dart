import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:click_connect_flutter_app/domain/entities/user/user_entity.dart';
import 'package:click_connect_flutter_app/presentation/cubit/user/cubit/user_cubit.dart';
import 'package:uuid/uuid.dart';

import '../../../core/commons/widgets/profile_widget.dart';
import '../../../core/constant/constants.dart';
import '../../../domain/entities/post/post_entity.dart';
import '../../../domain/usecases/firebase/storage/upload_image_to_storage_usecase.dart';
import '../../../injection_container.dart' as di;
import '../../cubit/post/cubit/post_cubit.dart';
import '../profile/widgets/profile_form_widget.dart';

class UploadPostPage extends StatefulWidget {
  const UploadPostPage({required this.currentUserUid, super.key});

  final String currentUserUid;

  @override
  State<UploadPostPage> createState() => _UploadPostPageState();
}

class _UploadPostPageState extends State<UploadPostPage> {
  final TextEditingController _descriptionController = TextEditingController();
  bool _isUploading = false;
  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  File? _image;

  Future _takeImage() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.camera);
      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        } else {
          print("No Image has been Selected");
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future _pickImage() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        } else {
          print("No Image has been Selected");
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    if (_image == null) {
      return Scaffold(
        backgroundColor: backGroundColor,
        body: Center(
          child: GestureDetector(
            onTap: () => _showDialogBox(themeData),
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: secondaryColor.withOpacity(.3),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.upload,
                  color: primaryColor,
                  size: 40,
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      return BlocBuilder<UserCubit, UserState>(
        builder: (context, userState) {
          if (userState is UsersLoaded) {
            final UserEntity currentUser = userState.users
                .firstWhere((user) => user.uid == widget.currentUserUid);
            return Scaffold(
              appBar: AppBar(
                leading: GestureDetector(
                  onTap: () => setState(() {
                    _image = null;
                  }),
                  child: const Icon(
                    Icons.close,
                    size: 32,
                  ),
                ),
                actions: [
                  GestureDetector(
                    onTap: () => _submitPost(currentUser),
                    child: const Icon(
                      Icons.arrow_forward,
                      size: 32,
                    ),
                  ),
                ],
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: profileWidget(imageUrl: currentUser.profileUrl),
                      ),
                    ),
                    sizeVer(10),
                    Text(
                      '${currentUser.username}',
                      style: themeData.textTheme.bodyLarge,
                    ),
                    sizeVer(10),
                    SizedBox(
                      width: double.infinity,
                      height: 250,
                      child: profileWidget(image: _image),
                    ),
                    sizeVer(30),
                    ProfileFormWidget(
                      controller: _descriptionController,
                      title: "Description",
                    ),
                    sizeVer(10),
                    _isUploading
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Uploading the Post. Please wait...",
                                style: themeData.textTheme.bodyLarge,
                              ),
                              sizeHor(10),
                              const CircularProgressIndicator()
                            ],
                          )
                        : const SizedBox(height: 0, width: 0),
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

  _showDialogBox(ThemeData themeData) {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          backgroundColor: backGroundColor,
          title: Text(
            'Create a Post',
            style: themeData.textTheme.titleLarge,
          ),
          children: [
            SimpleDialogOption(
              child: Text(
                'Take a photo',
                style: themeData.textTheme.headlineLarge,
              ),
              onPressed: () {
                Navigator.pop(context);
                _takeImage();
              },
            ),
            SimpleDialogOption(
              child: Text(
                'Choose from gallary',
                style: themeData.textTheme.headlineLarge,
              ),
              onPressed: () {
                Navigator.pop(context);
                _pickImage();
              },
            ),
            SimpleDialogOption(
              child: Text(
                'Cancel',
                style: themeData.textTheme.headlineLarge,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  _submitPost(UserEntity currentUser) async {
    setState(() {
      _isUploading = true;
    });
    final imageUrl =
        await di.sl<UploadImageToStorageUsecase>().call(_image, true, "posts");
    await _createSubmitPost(currentUser: currentUser, imageUrl: imageUrl);
  }

  _createSubmitPost(
      {required UserEntity currentUser, required String imageUrl}) {
    context.read<PostCubit>().createPost(
            post: PostEntity(
          postId: const Uuid().v1(),
          creatorUid: currentUser.uid,
          username: currentUser.username,
          decription: _descriptionController.text,
          createAt: Timestamp.now(),
          likes: const [],
          totalComments: 0,
          totalLikes: 0,
          userProfileUrl: currentUser.profileUrl,
          postImageUrl: imageUrl,
        ));
    setState(() {
      _isUploading = false;
      _image = null;
    });
    _descriptionController.clear();
  }
}
