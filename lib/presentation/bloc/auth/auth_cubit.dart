import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ia_bet/domain/usecases/get_current_uid_usecase.dart';
import 'package:ia_bet/domain/usecases/is_sign_in_usecase.dart';
import 'package:ia_bet/domain/usecases/sign_out_usecase.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final IsSignInUseCase isSignInUseCase;
  final GetCurrentUidUseCase getCurrentUidUseCase;
  final SignOutUseCase signOutUseCase;
  var globalUid;

  AuthCubit({
    required this.isSignInUseCase,
    required this.signOutUseCase,
    required this.getCurrentUidUseCase,
  }) : super(AuthInitial());

  Future<void> appStarted() async {
    try {
      bool isSignIn = await isSignInUseCase.call();

      if (isSignIn) {
        print('esta autenticado');
        final uid = await getCurrentUidUseCase.call();
        emit(Authenticated(uid: uid));
      } else {
        print('Não esta autenticado');
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
      print('uid do usuário é');
      print(uid);
      emit(Authenticated(uid: uid));
    } catch (_) {
      emit(UnAuthenticated());
    }
  }

  Future<void> loggedOut() async {
    try {
      print('Deslogando...');
      await signOutUseCase.call();
      emit(UnAuthenticated());
    } catch (_) {}
  }

  Future<String> getUid() async {
    return await getCurrentUidUseCase.call();
  }
}
