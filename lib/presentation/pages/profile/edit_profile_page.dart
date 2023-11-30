import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/commons/widgets/profile_widget.dart';
import '../../../core/constant/constants.dart';
import '../../../domain/entities/user/user_entity.dart';
import '../../../domain/usecases/firebase/storage/upload_image_to_storage_usecase.dart';
import '../../../injection_container.dart' as di;
import '../../cubit/user/cubit/user_cubit.dart';
import 'widgets/profile_form_widget.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({required this.user, super.key});
  final UserEntity user;
  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _usernameController;
  late TextEditingController _websiteController;
  late TextEditingController _bioController;
  bool isUpdating = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name!);
    _usernameController = TextEditingController(text: widget.user.username!);
    _websiteController = TextEditingController(text: widget.user.website!);
    _bioController = TextEditingController(text: widget.user.bio!);
  }

  File? _image;

  Future _selecteImage() async {
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
    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBar(
        backgroundColor: backGroundColor,
        title: const Text(
          "Edit Profile",
          style: TextStyle(
            color: primaryColor,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              icon: const Icon(
                Icons.check,
                color: blueColor,
                size: 32,
              ),
              onPressed: () async {
                await _updateUserProfileData();
                context.pop();
              },
            ),
          ),
        ],
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            color: primaryColor,
            size: 32,
          ),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: isUpdating
          ? const CircularProgressIndicator()
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: profileWidget(
                                imageUrl: widget.user.profileUrl,
                                image: _image)),
                      ),
                      sizeVer(15),
                      GestureDetector(
                        onTap: () async => await _selecteImage(),
                        child: const Text(
                          "Change profile picture",
                          style: TextStyle(
                            color: blueColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      sizeVer(30),
                      ProfileFormWidget(
                        controller: _nameController,
                        title: "Name",
                      ),
                      sizeVer(15),
                      ProfileFormWidget(
                        controller: _usernameController,
                        title: "Username",
                      ),
                      sizeVer(15),
                      ProfileFormWidget(
                        controller: _websiteController,
                        title: "Website",
                      ),
                      sizeVer(15),
                      ProfileFormWidget(
                        controller: _bioController,
                        title: "Bio",
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  _updateUserProfileData() async {
    if (_image == null) {
      _updateUserProfile(profileUrl: '');
    } else {
      final profileUrl = await di
          .sl<UploadImageToStorageUsecase>()
          .call(_image!, false, "profileImage");
      await _updateUserProfile(profileUrl: profileUrl);
    }
  }

  _updateUserProfile({required String profileUrl}) {
    setState(() {
      isUpdating = true;
    });
    context.read<UserCubit>().updateUser(
            user: UserEntity(
          uid: widget.user.uid,
          name: _nameController.text,
          username: _usernameController.text,
          website: _websiteController.text,
          bio: _bioController.text,
          profileUrl: profileUrl,
        ));
    setState(() {
      isUpdating = false;
    });
    _nameController.clear();
    _usernameController.clear();
    _websiteController.clear();
    _bioController.clear();
  }
}
