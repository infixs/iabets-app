import 'dart:io';

import 'package:flutter/foundation.dart';

import 'package:bloc/bloc.dart';
import 'package:device_info_plus/device_info_plus.dart';
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

      final Response response = await getLogin(data);

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
      debugPrint(e.toString());
      emit(PhoneAuthFailure());
    } catch (e) {
      debugPrint(e.toString());
      emit(PhoneAuthFailure());
    }
  }

  Future<String> getDeviceInfo() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    return (await deviceInfoPlugin.deviceInfo).toMap()['id'];
  }

  Future<void> submitProfileInfo(
      {required String name,
      required String profileUrl,
      required String phoneNumber,
      required String email,
      required String uid,
      required bool isAdmin}) async {
    try {
      final UserEntity user = UserEntity(
          uid: uid,
          name: name,
          email: email,
          phoneNumber: phoneNumber,
          isOnline: true,
          profileUrl: profileUrl,
          isAdmin: isAdmin,
          deviceId: await getDeviceInfo(),
          apiToken: apiToken);

      debugPrint('testando...');
      debugPrint(user.isAdmin.toString());
      await getCreateCurrentUserUseCase.call(user);
      emit(PhoneAuthSuccess());
      debugPrint('depois testando...');
      debugPrint(user.isAdmin.toString());
    } on SocketException catch (e) {
      debugPrint(e.toString());
      emit(PhoneAuthFailure());
    } catch (e) {
      debugPrint(e.toString());
      emit(PhoneAuthFailure());
    }
  }
}
