part of 'auth_email_cubit.dart';

abstract class EmailAuthState extends Equatable {
  const EmailAuthState();
}

class PhoneAuthInitial extends EmailAuthState {
  @override
  List<Object> get props => [];
}

class PhoneAuthLoading extends EmailAuthState {
  @override
  List<Object> get props => [];
}

class PhoneAuthSmsCodeReceived extends EmailAuthState {
  @override
  List<Object> get props => [];
  @override
  String toString() {
    debugPrint("auth sms received");
    return super.toString();
  }
}

class PhoneAuthProfileInfo extends EmailAuthState {
  @override
  List<Object> get props => [];
}

class PhoneAuthSuccess extends EmailAuthState {
  @override
  List<Object> get props => [];
}

class PhoneAuthFailure extends EmailAuthState {
  @override
  List<Object> get props => [];
}
