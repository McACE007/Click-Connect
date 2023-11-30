import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../domain/entities/user/user_entity.dart';
import '../../../../domain/usecases/firebase/user/sign_in_user_usecase.dart';
import '../../../../domain/usecases/firebase/user/sign_up_user_usecase.dart';

part 'user_credential_state.dart';

class UserCredentialCubit extends Cubit<UserCredentialState> {
  final SignInUserUsecase signInUserUsecase;
  final SignUpUserUsecase signUpUserUsecase;
  UserCredentialCubit({
    required this.signInUserUsecase,
    required this.signUpUserUsecase,
  }) : super(UserCredentialInitial());

  Future<void> signInUser({
    required String email,
    required String password,
  }) async {
    emit(UserCredentialLoading());
    final result =
        await signInUserUsecase(UserEntity(email: email, password: password));
    result.fold(
        (failure) =>
            emit(UserCredentialFailure(errorMessage: failure.errorMessage)),
        (_) => emit(UserCredentialSuccess()));
  }

  Future<void> signUpUser({
    required UserEntity user,
  }) async {
    emit(UserCredentialLoading());
    final result = await signUpUserUsecase(user);
    result.fold(
        (failure) =>
            emit(UserCredentialFailure(errorMessage: failure.errorMessage)),
        (_) => emit(UserCredentialSuccess()));
  }
}
