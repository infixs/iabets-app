import 'dart:io';

// ignore: import_of_legacy_library_into_null_safe
import 'package:bloc/bloc.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:equatable/equatable.dart';
import 'package:ia_bet/domain/entities/double_config.dart';
import 'package:ia_bet/domain/usecases/get_double_config_usecase.dart';

part 'double_config_state.dart';

class DoubleConfigCubit extends Cubit<DoubleConfigState> {
  final GetDoubleConfigUseCase getDoubleConfigUseCase;

  DoubleConfigCubit({
    required this.getDoubleConfigUseCase,
  }) : super(DoubleConfigInitial());

  Future<void> getDoubleConfig() async {
    try {
      final doubleConfigStreamData = getDoubleConfigUseCase.call();
      doubleConfigStreamData.listen((doubleConfigData) {
        emit(DoubleConfigLoaded(doubleConfig: doubleConfigData));
      });
    } on SocketException catch (_) {
    } catch (_) {}
  }

  Future<void> saveDoubleConfig() async {
    try {
      getDoubleConfigUseCase.call();
    } on SocketException catch (_) {
    } catch (_) {}
  }
}
