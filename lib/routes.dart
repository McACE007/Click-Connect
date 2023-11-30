import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'core/constant/route_names.dart';
import 'presentation/cubit/auth/cubit/auth_cubit.dart';
import 'presentation/pages/Auth/sign_in_page.dart';
import 'presentation/pages/Auth/sign_up_page.dart';
import 'presentation/pages/overview/overview_page.dart';

class MyRouter {
  GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) {
          return BlocBuilder<AuthCubit, AuthState>(
            builder: (context, authState) {
              // context.read<AuthCubit>().loggedOut();
              if (authState is Authenticated) {
                return OverviewPage(uid: authState.uid);
              }
              return const SignInPage();
            },
          );
        },
      ),
      GoRoute(
        name: RouteNames.signInPageRoute,
        path: '/sign-in',
        pageBuilder: (context, state) =>
            const MaterialPage(child: SignInPage()),
      ),
      GoRoute(
        name: RouteNames.signUpPageRoute,
        path: '/sign-up',
        pageBuilder: (context, state) =>
            const MaterialPage(child: SignUpPage()),
      ),
      GoRoute(
        name: RouteNames.overviewPageRoute,
        path: '/overview',
        pageBuilder: (context, state) => const MaterialPage(
            child: OverviewPage(
          uid: '',
        )),
      ),
    ],
  );
}
