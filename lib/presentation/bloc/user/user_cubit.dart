import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ia_bet/domain/entities/user_entity.dart';
import 'package:ia_bet/domain/usecases/create_one_to_one_chat_channel_usecase.dart';
import 'package:ia_bet/domain/usecases/get_all_user_usecase.dart';
import 'package:ia_bet/domain/usecases/get_current_usercase.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final GetAllUserUseCase getAllUserUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final CreateOneToOneChatChannelUseCase createOneToOneChatChannelUseCase;
  var allusersGlobal;

  UserCubit(
      {required this.getAllUserUseCase,
      required this.createOneToOneChatChannelUseCase,
      required this.getCurrentUserUseCase})
      : super(UserInitial());

  Future<void> getAllUsers() async {
    try {
      final userStreamData = getAllUserUseCase.call();
      userStreamData.listen((users) {
        emit(UserLoaded(users));
      });
    } on SocketException catch (_) {
      emit(UserFailure());
    } catch (_) {
      emit(UserFailure());
    }
  }

  Future<void> getCurrentUser() async {
    try {
      final userStreamData = getCurrentUserUseCase.call();
      userStreamData.listen((user) {
        emit(CurrentUserChanged(user));
      });
    } on SocketException catch (_) {
      emit(UserFailure());
    } catch (_) {
      emit(UserFailure());
    }
  }

  Future<UserEntity> getCurrentUserWithReturn() async {
    final userStreamData = getCurrentUserUseCase.call();
    userStreamData.listen((user) {
      //Escuta alterações no firebase de usuario
    });
    return userStreamData.first;
  }

  Future<void> createChatChannel({required String uid, required name}) async {
    List<UserEntity> allUsers = [];
    final userStreamData = await getAllUserUseCase.call();
    userStreamData.listen((users) {
      allUsers = users;
      allusersGlobal = users;
    });

    allUsers = await userStreamData.first;

    try {
      await createOneToOneChatChannelUseCase.call(uid, allUsers, name);
    } on SocketException catch (_) {
      emit(UserFailure());
    } catch (_) {
      emit(UserFailure());
    }
  }

  Future<List<UserEntity>> getAllUsersWithReturn() async {
    List<UserEntity> allUsers = [];
    final userStreamData = await getAllUserUseCase.call();
    userStreamData.listen((users) {
      allUsers = users;
      allusersGlobal = users;
    });

    return userStreamData.first;
  }
}
