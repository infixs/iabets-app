import 'package:equatable/equatable.dart';
import 'package:ia_bet/domain/entities/aviator_entity.dart';

abstract class AviatorState extends Equatable {
  const AviatorState();
}

class AviatorInitial extends AviatorState {
  @override
  List<Object> get props => [];
}

class AviatorLoaded extends AviatorState {
  final AviatorEntity aviatorEntity;

  const AviatorLoaded({required this.aviatorEntity});
  @override
  List<Object> get props => [aviatorEntity];
}
