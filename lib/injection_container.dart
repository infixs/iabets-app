import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:ia_bet/data/datasource/firebase_remote_datasource.dart';
import 'package:ia_bet/data/datasource/firebase_remote_datasource_impl.dart';
import 'package:ia_bet/data/repositories/firebase_repository_impl.dart';
import 'package:ia_bet/domain/repositories/firebase_repository.dart';
import 'package:ia_bet/domain/usecases/add_to_my_chat_usecase.dart';
import 'package:ia_bet/domain/usecases/create_one_to_one_chat_channel_usecase.dart';
import 'package:ia_bet/domain/usecases/get_all_user_usecase.dart';
import 'package:ia_bet/domain/usecases/get_create_current_user_usecase.dart';
import 'package:ia_bet/domain/usecases/get_current_uid_usecase.dart';
import 'package:ia_bet/domain/usecases/get_current_usercase.dart';
import 'package:ia_bet/domain/usecases/get_my_chat_usecase.dart';
import 'package:ia_bet/domain/usecases/get_one_to_one_single_user_chat_channel_usecase.dart';
import 'package:ia_bet/domain/usecases/get_text_messages_usecase.dart';
import 'package:ia_bet/domain/usecases/get_url_file_usecase.dart';
import 'package:ia_bet/domain/usecases/is_sign_in_usecase.dart';
import 'package:ia_bet/domain/usecases/send_text_message_usecase.dart';
import 'package:ia_bet/domain/usecases/set_user_token_usecase.dart';
import 'package:ia_bet/domain/usecases/sign_in_with_email_usecase.dart';
import 'package:ia_bet/domain/usecases/sign_in_with_phone_number_usecase.dart';
import 'package:ia_bet/domain/usecases/sign_out_usecase.dart';
import 'package:ia_bet/domain/usecases/upload_file_usecase.dart';
import 'package:ia_bet/domain/usecases/verify_phone_number_usecase.dart';
import 'package:ia_bet/presentation/bloc/auth/auth_cubit.dart';
import 'package:ia_bet/presentation/bloc/communication/communication_cubit.dart';
import 'package:ia_bet/presentation/bloc/my_chat/my_chat_cubit.dart';
import 'package:ia_bet/presentation/bloc/user/user_cubit.dart';

import 'presentation/bloc/auth_email/auth_email_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //Futures bloc
  sl.registerFactory<AuthCubit>(() => AuthCubit(
        signOutUseCase: sl.call(),
        isSignInUseCase: sl.call(),
        getCurrentUidUseCase: sl.call(),
      ));


  sl.registerFactory<CommunicationCubit>(() => CommunicationCubit(
        addToMyChatUseCase: sl.call(),
        getOneToOneSingleUserChatChannelUseCase: sl.call(),
        getTextMessagesUseCase: sl.call(),
        sendTextMessageUseCase: sl.call(),
        getAllUserUseCase: sl.call(),
        getUrlFileUseCase: sl.call(), 
        uploadFiletUseCase: sl.call()
      ));
  sl.registerFactory<MyChatCubit>(() => MyChatCubit(
        getMyChatUseCase: sl.call(),
      ));



  sl.registerFactory<UserCubit>(() => UserCubit(
        createOneToOneChatChannelUseCase: sl.call(),
        getAllUserUseCase: sl.call(),
        setUserTokenUseCase: sl.call(),
        getCurrentUserUseCase: sl.call()
      ));

  sl.registerFactory<EmailAuthCubit>(() => EmailAuthCubit(
    signInWithEmailUseCase: sl.call(),
    getCurrentUidUseCase: sl.call(),
    getCreateCurrentUserUseCase: sl.call()
    ));

  //useCase
  sl.registerLazySingleton<GetCreateCurrentUserUseCase>(
      () => GetCreateCurrentUserUseCase(repository: sl.call()));
  sl.registerLazySingleton<GetCurrentUidUseCase>(
      () => GetCurrentUidUseCase(repository: sl.call()));
  sl.registerLazySingleton<IsSignInUseCase>(
      () => IsSignInUseCase(repository: sl.call()));
  sl.registerLazySingleton<SignInWithPhoneNumberUseCase>(
      () => SignInWithPhoneNumberUseCase(repository: sl.call()));
  sl.registerLazySingleton<SignOutUseCase>(
      () => SignOutUseCase(repository: sl.call()));
  sl.registerLazySingleton<VerifyPhoneNumberUseCase>(
      () => VerifyPhoneNumberUseCase(repository: sl.call()));
  sl.registerLazySingleton<SignInWithEmailUseCase>(
      () => SignInWithEmailUseCase(repository: sl.call()));

  sl.registerLazySingleton<GetAllUserUseCase>(
      () => GetAllUserUseCase(repository: sl.call()));
  sl.registerLazySingleton<GetCurrentUserUseCase>(
      () => GetCurrentUserUseCase(repository: sl.call()));
  sl.registerLazySingleton<SetUserTokenUseCase>(
      () => SetUserTokenUseCase(repository: sl.call()));
  sl.registerLazySingleton<GetMyChatUseCase>(
      () => GetMyChatUseCase(repository: sl.call()));
  sl.registerLazySingleton<GetTextMessagesUseCase>(
      () => GetTextMessagesUseCase(repository: sl.call()));
  sl.registerLazySingleton<SendTextMessageUseCase>(
      () => SendTextMessageUseCase(repository: sl.call()));
  sl.registerLazySingleton<AddToMyChatUseCase>(
      () => AddToMyChatUseCase(repository: sl.call()));
  sl.registerLazySingleton<CreateOneToOneChatChannelUseCase>(
      () => CreateOneToOneChatChannelUseCase(repository: sl.call()));
  sl.registerLazySingleton<GetOneToOneSingleUserChatChannelUseCase>(
      () => GetOneToOneSingleUserChatChannelUseCase(repository: sl.call()));
  sl.registerLazySingleton<GetUrlFileUseCase>(
      () => GetUrlFileUseCase(repository: sl.call()));
  sl.registerLazySingleton<UploadFiletUseCase>(
      () => UploadFiletUseCase(repository: sl.call()));

  //repository
  sl.registerLazySingleton<FirebaseRepository>(
      () => FirebaseRepositoryImpl(remoteDataSource: sl.call()));

  //remote data
  sl.registerLazySingleton<FirebaseRemoteDataSource>(
      () => FirebaseRemoteDataSourceImpl(
            auth: sl.call(),
            fireStore: sl.call(),
          ));
  //External

  final auth = FirebaseAuth.instance;
  final fireStore = FirebaseFirestore.instance;
  sl.registerLazySingleton(() => auth);
  sl.registerLazySingleton(() => fireStore);
}
