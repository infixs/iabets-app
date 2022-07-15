import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ia_bet/domain/entities/double_config.dart';
import 'package:ia_bet/domain/repositories/firebase_repository.dart';

import '../../../../data/model/double_config_model.dart';
import '../../../../domain/entities/strategy_entity.dart';

part 'double_config_state.dart';

class DoubleConfigCubit extends Cubit<DoubleConfigState> {
  final FirebaseRepository firebaseRepository;
  DoubleConfigCubit(this.firebaseRepository) : super(DoubleConfigInitial());

  Future<void> getDoubleConfig() async {
    try {
      final doubleConfigStreamData = firebaseRepository.getDoubleConfig();
      doubleConfigStreamData.listen((doubleConfigData) {
        emit(DoubleConfigLoaded(doubleConfig: doubleConfigData));
      });
    } on SocketException catch (_) {
    } catch (_) {}
  }

  Future<void> saveDoubleConfig(DoubleConfigModel doubleConfig) async {
    try {
      firebaseRepository.saveDoubleConfig(doubleConfig);
    } on SocketException catch (_) {
    } catch (_) {}
  }

  Future<List<StrategyEntity>> getStrategies() async {
    return firebaseRepository.getStrategies();
  }
}
