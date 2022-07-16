import 'package:equatable/equatable.dart';
import 'package:ia_bet/domain/entities/crash_entity.dart';

abstract class CrashState extends Equatable {
  const CrashState();
}

class CrashInitial extends CrashState {
  @override
  List<Object> get props => [];
}

class CrashLoaded extends CrashState {
  final CrashEntity crashEntity;

  const CrashLoaded({required this.crashEntity});
  @override
  List<Object> get props => [crashEntity];
}
