import 'package:ia_bet/domain/repositories/firebase_repository.dart';

class ResetPasswordUseCase {
  final FirebaseRepository repository;

  ResetPasswordUseCase({required this.repository});

  Future<bool> call(String email) async {
    return await repository.resetPassword(email: email);
  }
}
