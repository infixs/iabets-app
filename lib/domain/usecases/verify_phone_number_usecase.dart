import 'package:ia_bet/domain/repositories/firebase_repository.dart';

class VerifyPhoneNumberUseCase{

  final FirebaseRepository repository;

  VerifyPhoneNumberUseCase({required this.repository});

  Future<void> call(String phoneNumber)async{
    return await repository.verifyPhoneNumber(phoneNumber);
  }
}