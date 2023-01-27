import 'dart:io';

import 'package:bloc/bloc.dart';

import '../../../../domain/repositories/firebase_repository.dart';

import 'aviator_state.dart';

class AviatorCubit extends Cubit<AviatorState> {
  final FirebaseRepository firebaseRepository;
  AviatorCubit(this.firebaseRepository) : super(AviatorInitial());

  Future<void> getAviator() async {
    try {
      final aviatorStream = firebaseRepository.getAviatorEntity();
      aviatorStream.listen((aviator) {
        if (aviator != null) {
          emit(AviatorLoaded(aviatorEntity: aviator));
        }
      });
    } on SocketException catch (_) {
    } catch (_) {}
  }
}
