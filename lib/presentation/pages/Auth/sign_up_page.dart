import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:click_connect_flutter_app/core/commons/widgets/profile_widget.dart';
import '../../../domain/entities/user/user_entity.dart';
import '../../cubit/auth/cubit/auth_cubit.dart';

import '../../../core/constant/constants.dart';
import '../../../core/constant/route_names.dart';
import '../../cubit/userCreadential/cubit/user_credential_cubit.dart';
import '../../widgets/button_container_widget.dart';
import '../../widgets/form_container_widget.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _bioController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _bioController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  _trySubmitting() {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      FocusScope.of(context).unfocus();
      _signUpUser();
    }
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
    return Scaffold(
      backgroundColor: backGroundColor,
      body: BlocConsumer<UserCredentialCubit, UserCredentialState>(
        listener: (context, userCredentialState) {
          if (userCredentialState is UserCredentialSuccess) {
            context.read<AuthCubit>().loggedIn();
            context.go('/');
          }
          if (userCredentialState is UserCredentialFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  userCredentialState.errorMessage,
                  style: themeData.textTheme.bodyLarge,
                ),
                showCloseIcon: true,
              ),
            );
          }
        },
        builder: (context, userCredentialState) {
          return SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      flex: 2,
                      child: Container(),
                    ),
                    SvgPicture.asset(
                      "assets/ic_instagram.svg",
                      color: primaryColor,
                    ),
                    sizeVer(20),
                    Stack(
                      children: [
                        SizedBox(
                          width: 60,
                          height: 60,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(35),
                              child: profileWidget(image: _image)),
                        ),
                        Positioned(
                          right: -10,
                          bottom: -15,
                          child: IconButton(
                            onPressed: () => _showDialogBox(themeData),
                            icon: const Icon(
                              Icons.add_a_photo,
                              color: blueColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    sizeVer(30),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          FormContainerWidget(
                            hintText: "Enter your username",
                            controller: _usernameController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Username can not be empty.';
                              }
                              return null;
                            },
                          ),
                          sizeVer(20),
                          FormContainerWidget(
                            hintText: "Enter your email",
                            controller: _emailController,
                            validator: (value) {
                              RegExp regExp =
                                  RegExp("[a-z0-9]+@[a-z]+\\.[a-z]{2,3}");
                              if (!regExp.hasMatch(value!)) {
                                return "Enter a valid email addreass.";
                              }
                              return null;
                            },
                          ),
                          sizeVer(20),
                          FormContainerWidget(
                            hintText: "Enter your password",
                            isPasswordField: true,
                            controller: _passwordController,
                            validator: (value) {
                              var msg = '';
                              if (!RegExp(".{8,20}").hasMatch(value!)) {
                                msg += "It contains at least 8 characters.\n";
                              }
                              if (!RegExp("(?=.*[0-9])").hasMatch(value)) {
                                msg += "It contains at least one digit.\n";
                              }
                              if (!RegExp("(?=.*[a-z])").hasMatch(value)) {
                                msg +=
                                    "It contains at least one lower case alphabet.\n";
                              }
                              if (!RegExp("(?=.*[A-Z])").hasMatch(value)) {
                                msg +=
                                    "It contains at least one upper case alphabet.\n";
                              }
                              if (msg.isNotEmpty) {
                                return msg.trim();
                              }
                              return null;
                            },
                          ),
                          sizeVer(20),
                          FormContainerWidget(
                            hintText: "Enter your bio",
                            controller: _bioController,
                          ),
                        ],
                      ),
                    ),
                    sizeVer(25),
                    ButtonContainerWidget(
                      color: blueColor,
                      text: 'Sign Up',
                      onTapListener: () => _trySubmitting(),
                    ),
                    Flexible(
                      flex: 2,
                      child: Container(),
                    ),
                    const Divider(
                      color: secondaryColor,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account? ",
                          style: TextStyle(
                            color: primaryColor,
                          ),
                        ),
                        InkWell(
                          onTap: () => context
                              .pushReplacementNamed(RouteNames.signInPageRoute),
                          child: const Text(
                            "Sign In.",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: blueColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    sizeVer(10),
                    userCredentialState is UserCredentialLoading
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Please wait...",
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
        },
      ),
    );
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

  _signUpUser() async {
    await context.read<UserCredentialCubit>().signUpUser(
            user: UserEntity(
          username: _usernameController.text,
          email: _emailController.text,
          password: _passwordController.text,
          bio: _bioController.text,
          name: '',
          website: '',
          followers: const [],
          following: const [],
          totalFollowers: 0,
          totalFollowing: 0,
          totalPosts: 0,
          imageFile: _image,
        ));
    _clear();
  }

  _clear() {
    _usernameController.clear();
    _emailController.clear();
    _passwordController.clear();
    _bioController.clear();
  }
}
