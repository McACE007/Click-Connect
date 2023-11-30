import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../domain/usecases/firebase/user/follow_unfollow_user_usecase.dart';

import '../../../../domain/entities/user/user_entity.dart';
import '../../../../domain/usecases/firebase/user/get_single_user_usecase.dart';
import '../../../../domain/usecases/firebase/user/get_all_users_usecase.dart';
import '../../../../domain/usecases/firebase/user/update_user_usecase.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UpdateUserUsecase updateUserUsecase;
  final GetAllUsersUsecase getAllUsersUsecase;
  final GetSingleUserUsecase getSingleUserUsecase;
  final FollowUnfollowUserUsecase followUnfollowUserUsecase;

  UserCubit({
    required this.getSingleUserUsecase,
    required this.updateUserUsecase,
    required this.getAllUsersUsecase,
    required this.followUnfollowUserUsecase,
  }) : super(UserInitial());

  Future<void> getAllUsers() async {
    emit(UserLoading());
    try {
      final streamResponse = getAllUsersUsecase();
      streamResponse.listen((users) {
        emit(UsersLoaded(users: users));
      });
    } catch (e) {
      emit(UserFailure(errorMessage: e.toString()));
    }
  }

  Future<void> updateUser({required UserEntity user}) async {
    try {
      await updateUserUsecase(user);
    } catch (e) {
      emit(UserFailure(errorMessage: e.toString()));
    }
  }

  Future<void> followUnfollowUser({required UserEntity user}) async {
    try {
      await followUnfollowUserUsecase(user);
    } catch (e) {
      print(e.toString() + 'hey');
    }
  }
}
