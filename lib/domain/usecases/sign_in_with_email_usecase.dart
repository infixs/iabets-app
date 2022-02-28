import 'package:ia_bet/domain/repositories/firebase_repository.dart';

class SignInWithEmailUseCase{
  final FirebaseRepository repository;

  SignInWithEmailUseCase({required this.repository});

  Future<void> call({required String email, required String password})async{
    return await repository.signInWithEmail(email:email, password:password);
  }
}