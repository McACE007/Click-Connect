import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/commons/widgets/profile_widget.dart';
import '../../../core/constant/constants.dart';
import '../../../domain/entities/post/post_entity.dart';
import '../../../domain/usecases/firebase/storage/upload_image_to_storage_usecase.dart';
import '../../../injection_container.dart' as di;
import '../../cubit/post/cubit/post_cubit.dart';
import '../profile/widgets/profile_form_widget.dart';

class UpdatePostPage extends StatefulWidget {
  const UpdatePostPage({required this.post, super.key});
  final PostEntity post;
  @override
  State<UpdatePostPage> createState() => _UpdatePostPageState();
}

class _UpdatePostPageState extends State<UpdatePostPage> {
  final TextEditingController _descriptionController = TextEditingController();
  bool _isUpdating = false;

  @override
  void initState() {
    _descriptionController.text = widget.post.decription!;
    super.initState();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  File? _image;

  Future _pickImage() async {
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

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: const Icon(
            Icons.close,
            size: 32,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: _updatePost,
              child: const Icon(
                Icons.check,
                color: blueColor,
                size: 32,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          child: Column(
            children: [
              SizedBox(
                width: 40,
                height: 40,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: profileWidget(imageUrl: widget.post.userProfileUrl),
                ),
              ),
              sizeVer(10),
              Text(
                "${widget.post.username}",
                style: themeData.textTheme.headlineLarge,
              ),
              sizeVer(10),
              Stack(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 250,
                    child: profileWidget(
                      imageUrl: widget.post.postImageUrl,
                      image: _image,
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: const CircleAvatar(
                        backgroundColor: primaryColor,
                        radius: 15,
                        child: Icon(
                          Icons.edit,
                          color: blueColor,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              sizeVer(15),
              ProfileFormWidget(
                title: "Write your decription",
                controller: _descriptionController,
              ),
              sizeVer(10),
              _isUpdating
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Updating the Post. Please wait...",
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
      ),
    );
  }

  _updatePost() async {
    setState(() {
      _isUpdating = true;
    });
    if (_image != null) {
      final imageUrl = await di
          .sl<UploadImageToStorageUsecase>()
          .call(_image, true, "posts");
      _createUpdatePost(imageUrl: imageUrl);
    } else {
      _createUpdatePost(imageUrl: widget.post.postImageUrl!);
    }
  }

  _createUpdatePost({required String imageUrl}) {
    context.read<PostCubit>().updatePost(
            post: PostEntity(
          postId: widget.post.postId,
          creatorUid: widget.post.creatorUid,
          postImageUrl: imageUrl,
          decription: _descriptionController.text,
        ));
    setState(() {
      _isUpdating = false;
      _image = null;
    });
    _descriptionController.clear();
    Navigator.pop(context);
  }
}
