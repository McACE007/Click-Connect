import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:click_connect_flutter_app/domain/usecases/firebase/user/follow_unfollow_user_usecase.dart';

import 'data/data_sources/remore_data_sources/remote_data_source.dart';
import 'data/repositoires/firebase_repo.dart';
import 'domain/repositories/firebase_repo.dart';
import 'domain/usecases/firebase/comment/create_comment_usecase.dart';
import 'domain/usecases/firebase/comment/delete_comment_usecase.dart';
import 'domain/usecases/firebase/comment/get_comment_usecase.dart';
import 'domain/usecases/firebase/comment/like_comment_usecase.dart';
import 'domain/usecases/firebase/comment/update_comment_usecase.dart';
import 'domain/usecases/firebase/post/create_post_usecase.dart';
import 'domain/usecases/firebase/post/delete_post_usecase.dart';
import 'domain/usecases/firebase/post/get_posts_usecase.dart';
import 'domain/usecases/firebase/post/like_post_usecase.dart';
import 'domain/usecases/firebase/post/update_post_usecase.dart';
import 'domain/usecases/firebase/reply/create_reply_usecase.dart';
import 'domain/usecases/firebase/reply/delete_reply_usecase.dart';
import 'domain/usecases/firebase/reply/get_replys_usecase.dart';
import 'domain/usecases/firebase/reply/like_reply_usecase.dart';
import 'domain/usecases/firebase/storage/upload_image_to_storage_usecase.dart';
import 'domain/usecases/firebase/user/get_all_users_usecase.dart';
import 'domain/usecases/firebase/user/get_current_uid_usecase.dart';
import 'domain/usecases/firebase/user/get_single_user_usecase.dart';
import 'domain/usecases/firebase/user/is_sign_in_usercase.dart';
import 'domain/usecases/firebase/user/sign_in_user_usecase.dart';
import 'domain/usecases/firebase/user/sign_out_usecase.dart';
import 'domain/usecases/firebase/user/sign_up_user_usecase.dart';
import 'domain/usecases/firebase/user/update_user_usecase.dart';
import 'presentation/cubit/auth/cubit/auth_cubit.dart';
import 'presentation/cubit/comment/cubit/comment_cubit.dart';
import 'presentation/cubit/comment_page/cubit/comment_page_cubit.dart';
import 'presentation/cubit/post/cubit/post_cubit.dart';
import 'presentation/cubit/reply/cubit/reply_cubit.dart';
import 'presentation/cubit/user/cubit/user_cubit.dart';
import 'presentation/cubit/userCreadential/cubit/user_credential_cubit.dart';

final sl = GetIt.asNewInstance();

Future<void> init() async {
  //cubits
  sl.registerFactory(() => AuthCubit(
        isSignInUsecase: sl(),
        getCurrentUidUsecase: sl(),
        signOutUsecase: sl(),
      ));

  sl.registerFactory(() => UserCubit(
        getAllUsersUsecase: sl(),
        updateUserUsecase: sl(),
        getSingleUserUsecase: sl(),
        followUnfollowUserUsecase: sl(),
      ));
  sl.registerFactory(
    () => UserCredentialCubit(
      signInUserUsecase: sl(),
      signUpUserUsecase: sl(),
    ),
  );

  sl.registerFactory(
    () => PostCubit(
      createPostUsecase: sl(),
      updatePostUsecase: sl(),
      deletePostUsecase: sl(),
      likePostUsecase: sl(),
      getPostUsecase: sl(),
    ),
  );

  sl.registerFactory(
    () => CommentCubit(
      createCommentUsecase: sl(),
      updateCommentUsecase: sl(),
      deleteCommentUsecase: sl(),
      likeCommentUsecase: sl(),
      getCommentUsecase: sl(),
    ),
  );

  sl.registerFactory(
    () => ReplyCubit(
      createReplyUsecase: sl(),
      deleteReplyUsecase: sl(),
      likeReplyUsecase: sl(),
      getReplysUsecase: sl(),
    ),
  );

  sl.registerFactory(
    () => CommentPageCubit(),
  );

  //User Usecases
  sl.registerLazySingleton(() => SignOutUsecase(sl()));
  sl.registerLazySingleton(() => GetCurrentUidUsecase(sl()));
  sl.registerLazySingleton(() => IsSignInUsecase(sl()));

  sl.registerLazySingleton(() => SignInUserUsecase(sl()));
  sl.registerLazySingleton(() => SignUpUserUsecase(sl()));

  sl.registerLazySingleton(() => GetAllUsersUsecase(sl()));
  sl.registerLazySingleton(() => UpdateUserUsecase(sl()));
  sl.registerLazySingleton(() => GetSingleUserUsecase(sl()));
  sl.registerLazySingleton(() => FollowUnfollowUserUsecase(sl()));

  //Cloud Storage Usecases
  sl.registerLazySingleton(() => UploadImageToStorageUsecase(sl()));

  //Post Usecases
  sl.registerLazySingleton(() => CreatePostUsecase(sl()));
  sl.registerLazySingleton(() => UpdatePostUsecase(sl()));
  sl.registerLazySingleton(() => DeletePostUsecase(sl()));
  sl.registerLazySingleton(() => LikePostUsecase(sl()));
  sl.registerLazySingleton(() => GetPostUsecase(sl()));

  //Comment Usecases
  sl.registerLazySingleton(() => CreateCommentUsecase(sl()));
  sl.registerLazySingleton(() => UpdateCommentUsecase(sl()));
  sl.registerLazySingleton(() => DeleteCommentUsecase(sl()));
  sl.registerLazySingleton(() => LikeCommentUsecase(sl()));
  sl.registerLazySingleton(() => GetCommentUsecase(sl()));

  //Reply Usecases
  sl.registerLazySingleton(() => CreateReplyUsecase(sl()));
  sl.registerLazySingleton(() => DeleteReplyUsecase(sl()));
  sl.registerLazySingleton(() => LikeReplyUsecase(sl()));
  sl.registerLazySingleton(() => GetReplysUsecase(sl()));

  // Respository
  sl.registerLazySingleton<FirebaseRepo>(() => FirebaseRepoImpl(sl()));

  // DataSource
  sl.registerLazySingleton<RemoteDataSource>(() => RemoteDataSourceImpl(
        sl(),
        sl(),
        sl(),
      ));

  // External
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseStorage.instance);
}
