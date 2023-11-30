import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constant/constants.dart';
import '../../../core/constant/route_names.dart';
import '../../cubit/auth/cubit/auth_cubit.dart';
import '../../cubit/userCreadential/cubit/user_credential_cubit.dart';
import '../../widgets/button_container_widget.dart';
import '../../widgets/form_container_widget.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  _trySubmitting() {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      FocusScope.of(context).unfocus();
      _signInUser(_emailController.text, _passwordController.text);
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
          } else if (userCredentialState is UserCredentialFailure) {
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
          return Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  flex: 2,
                  child: Container(),
                ),
                SvgPicture.asset(
                  "assets/Logo.svg",
                  width: 250,
                ),
                sizeVer(30),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      FormContainerWidget(
                        hintText: "Email",
                        controller: _emailController,
                        validator: (value) {
                          RegExp regExp = RegExp("[a-z0-9]+@[a-z]+.[a-z]{2,3}");
                          if (!regExp.hasMatch(value!)) {
                            return "Enter a valid email addreass.";
                          }
                          return null;
                        },
                      ),
                      sizeVer(20),
                      FormContainerWidget(
                        hintText: "Password",
                        controller: _passwordController,
                        isPasswordField: true,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter a valid password.';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                sizeVer(25),
                ButtonContainerWidget(
                  color: blueColor,
                  text: 'Sign In',
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
                      "Already have an account? ",
                      style: TextStyle(
                        color: primaryColor,
                      ),
                    ),
                    InkWell(
                      onTap: () =>
                          context.pushNamed(RouteNames.signUpPageRoute),
                      child: const Text(
                        "Sign Up.",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: blueColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _signInUser(String email, String password) async {
    await context
        .read<UserCredentialCubit>()
        .signInUser(email: email, password: password);
  }
}
