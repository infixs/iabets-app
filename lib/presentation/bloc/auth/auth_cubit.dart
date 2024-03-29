import 'package:flutter/foundation.dart';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ia_bet/domain/usecases/get_current_uid_usecase.dart';
import 'package:ia_bet/domain/usecases/is_sign_in_usecase.dart';
import 'package:ia_bet/domain/usecases/sign_out_usecase.dart';

import '../../../domain/repositories/firebase_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final IsSignInUseCase isSignInUseCase;
  final GetCurrentUidUseCase getCurrentUidUseCase;
  final SignOutUseCase signOutUseCase;
  final FirebaseRepository firebaseRepository;
  late final String globalUid;

  AuthCubit({
    required this.isSignInUseCase,
    required this.signOutUseCase,
    required this.getCurrentUidUseCase,
    required this.firebaseRepository,
  }) : super(AuthInitial());

  Future<void> appStarted() async {
    try {
      bool isSignIn = await isSignInUseCase.call();

      if (isSignIn) {
        debugPrint('esta autenticado');
        final uid = await getCurrentUidUseCase.call();
        firebaseRepository.setDeviceidToken();
        emit(Authenticated(uid: uid));
      } else {
        debugPrint('Não esta autenticado');
        emit(UnAuthenticated());
      }
    } catch (_) {
      emit(UnAuthenticated());
    }
  }

  Future<void> loggedIn() async {
    try {
      final uid = await getCurrentUidUseCase.call();
      globalUid = uid;
      debugPrint('uid do usuário é');
      debugPrint(uid);
      emit(Authenticated(uid: uid));
    } catch (_) {
      emit(UnAuthenticated());
    }
  }

  Future<void> loggedOut() async {
    try {
      debugPrint('Deslogando...');
      await signOutUseCase.call();
      emit(UnAuthenticated());
    } catch (_) {}
  }

  Future<String> getUid() async {
    return await getCurrentUidUseCase.call();
  }
}
