part of 'communication_cubit.dart';


abstract class CommunicationState extends Equatable {
  const CommunicationState();
}

class CommunicationInitial extends CommunicationState {
  @override
  List<Object> get props => [];
}
class CommunicationLoaded extends CommunicationState {
  final List<TextMessageEntity> messages;

  CommunicationLoaded({required this.messages});

  @override
  List<Object> get props => [messages];
}
class CommunicationFailure extends CommunicationState {
  @override
  List<Object> get props => [];
}
class CommunicationLoading extends CommunicationState {
  @override
  List<Object> get props => [];
}


abstract class FileState extends Equatable {
  const FileState();
}

class FileInitial extends FileState {
  @override
  List<Object> get props => [];
}

class FileLoading extends FileState {
  @override
  List<Object> get props => [];
}

class FileReady extends FileState {
  @override
  List<Object> get props => [];
}