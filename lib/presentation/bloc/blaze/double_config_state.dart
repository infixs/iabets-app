part of 'double_config_cubit.dart';

abstract class DoubleConfigState extends Equatable {
  const DoubleConfigState();
}

class DoubleConfigInitial extends DoubleConfigState {
  @override
  List<Object> get props => [];
}

class DoubleConfigLoaded extends DoubleConfigState {
  final DoubleConfigEntity doubleConfig;

  const DoubleConfigLoaded({required this.doubleConfig});
  @override
  List<Object> get props => [doubleConfig];
}
