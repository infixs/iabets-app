import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:ia_bet/data/datasource/api.dart';
import 'package:ia_bet/domain/entities/user_entity.dart';
import 'package:ia_bet/domain/usecases/get_create_current_user_usecase.dart';
import 'package:ia_bet/domain/usecases/get_current_uid_usecase.dart';
import 'package:ia_bet/domain/usecases/sign_in_with_email_usecase.dart';

part 'auth_email_state.dart';

class EmailAuthCubit extends Cubit<EmailAuthState> {
  final SignInWithEmailUseCase signInWithEmailUseCase;
  final GetCurrentUidUseCase getCurrentUidUseCase;
  final GetCreateCurrentUserUseCase getCreateCurrentUserUseCase;

  EmailAuthCubit(
      {required this.signInWithEmailUseCase,
      required this.getCurrentUidUseCase,
      required this.getCreateCurrentUserUseCase})
      : super(PhoneAuthInitial());

  //get getCreateCurrentUserUseCase => null;

  Future<void> submitVerifyPhoneNumber(
      {required String email, required String password}) async {
    emit(PhoneAuthLoading());
    try {
      var data = {"email": email, "password": password};

      Response response = await getLogin(data);

      if (response.data['user'] != 'user not found') {
        await signInWithEmailUseCase.call(email: email, password: password);

        var uid = await getCurrentUidUseCase.call();

        await submitProfileInfo(
            name: response.data['user']['name'] ?? email,
            profileUrl: '',
            phoneNumber: '',
            email: email,
            uid: uid,
            isAdmin: response.data['user']['is_admin'] == 1 ? true : false);
      }

      emit(PhoneAuthSmsCodeReceived());
    } on SocketException catch (e) {
      print(e);
      emit(PhoneAuthFailure());
    } catch (e) {
      print(e);
      emit(PhoneAuthFailure());
    }
  }

  Future<void> submitProfileInfo(
      {required String name,
      required String profileUrl,
      required String phoneNumber,
      required String email,
      required String uid,
      required bool isAdmin}) async {
    try {
      UserEntity user = UserEntity(
          uid: uid,
          name: name,
          email: email,
          phoneNumber: phoneNumber,
          isOnline: true,
          profileUrl: profileUrl,
          isAdmin: isAdmin);
      
      print('testando...');
      print(user.isAdmin);
      await getCreateCurrentUserUseCase.call(user);
      emit(PhoneAuthSuccess());
      print('depois testando...');
      print(user.isAdmin);
    } on SocketException catch (e) {
      print(e);
      emit(PhoneAuthFailure());
    } catch (e) {
      print(e);
      emit(PhoneAuthFailure());
    }
  }
}
