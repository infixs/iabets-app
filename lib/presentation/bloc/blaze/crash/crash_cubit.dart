import 'dart:io';

import 'package:bloc/bloc.dart';

import '../../../../domain/repositories/firebase_repository.dart';

import 'crash_state.dart';

class CrashCubit extends Cubit<CrashState> {
  final FirebaseRepository firebaseRepository;
  CrashCubit(this.firebaseRepository) : super(CrashInitial());

  Future<void> getCrash() async {
    try {
      final crashStream = firebaseRepository.getCrashEntity();
      crashStream.listen((crash) {
        if (crash != null) {
          emit(CrashLoaded(crashEntity: crash));
        }
      });
    } on SocketException catch (_) {
    } catch (_) {}
  }
}
