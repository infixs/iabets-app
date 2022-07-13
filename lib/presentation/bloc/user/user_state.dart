part of 'user_cubit.dart';

abstract class UserState extends Equatable {
  const UserState();
}

class UserInitial extends UserState {
  @override
  List<Object> get props => [];
}

class UserLoading extends UserState {
  @override
  List<Object> get props => [];
}

class UserLoaded extends UserState {
  final List<UserEntity> users;

  const UserLoaded(this.users);
  @override
  List<Object> get props => [users];
}

class CurrentUserChanged extends UserState {
  final UserEntity user;

  const CurrentUserChanged(this.user);
  @override
  List<Object> get props => [user];
}

class UserFailure extends UserState {
  @override
  List<Object> get props => [];
}
