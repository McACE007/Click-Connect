import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../domain/usecases/firebase/user/get_current_uid_usecase.dart';
import '../../../../domain/usecases/firebase/user/is_sign_in_usercase.dart';
import '../../../../domain/usecases/firebase/user/sign_out_usecase.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final IsSignInUsecase isSignInUsecase;
  final GetCurrentUidUsecase getCurrentUidUsecase;
  final SignOutUsecase signOutUsecase;
  AuthCubit({
    required this.isSignInUsecase,
    required this.getCurrentUidUsecase,
    required this.signOutUsecase,
  }) : super(AuthInitial());

  Future<void> appStarted(BuildContext context) async {
    try {
      bool isSignIn = await isSignInUsecase();
      if (isSignIn) {
        final uid = await getCurrentUidUsecase();
        emit(Authenticated(uid));
      } else {
        emit(UnAuthenticated());
      }
    } catch (_) {
      emit(UnAuthenticated());
    }
  }

  Future<void> loggedIn() async {
    try {
      final uid = await getCurrentUidUsecase();
      emit(Authenticated(uid));
    } catch (_) {
      emit(UnAuthenticated());
    }
  }

  Future<void> loggedOut() async {
    try {
      await signOutUsecase();
      emit(UnAuthenticated());
    } catch (_) {
      emit(UnAuthenticated());
    }
  }
}
