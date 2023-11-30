import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:click_connect_flutter_app/presentation/cubit/comment_page/cubit/comment_page_cubit.dart';

import 'core/constant/constants.dart';
import 'injection_container.dart';
import 'presentation/cubit/auth/cubit/auth_cubit.dart';
import 'presentation/cubit/comment/cubit/comment_cubit.dart';
import 'presentation/cubit/post/cubit/post_cubit.dart';
import 'presentation/cubit/reply/cubit/reply_cubit.dart';
import 'presentation/cubit/user/cubit/user_cubit.dart';
import 'presentation/cubit/userCreadential/cubit/user_credential_cubit.dart';
import 'routes.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<AuthCubit>()..appStarted(context),
        ),
        BlocProvider(
          create: (context) => sl<UserCredentialCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<UserCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<PostCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<CommentCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<ReplyCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<CommentPageCubit>(),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: MyRouter().router,
        debugShowCheckedModeBanner: false,
        title: 'Instagram Clone',
        themeMode: ThemeMode.dark,
        darkTheme: ThemeData(
          scaffoldBackgroundColor: backGroundColor,
          primaryColor: primaryColor,
          secondaryHeaderColor: secondaryColor,
          backgroundColor: backGroundColor,
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            color: backGroundColor,
            foregroundColor: primaryColor,
          ),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(
              color: primaryColor,
              fontSize: 14,
            ),
            bodyMedium: TextStyle(
              color: darkGreyColor,
            ),
            bodySmall: TextStyle(
              color: darkGreyColor,
              fontSize: 12,
            ),
            titleLarge: TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            headlineLarge: TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            headlineMedium: TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          iconTheme: const IconThemeData(
            color: primaryColor,
          ),
          bottomSheetTheme: const BottomSheetThemeData(
            dragHandleColor: primaryColor,
            backgroundColor: backGroundColor,
          ),
        ),
      ),
    );
  }
}
