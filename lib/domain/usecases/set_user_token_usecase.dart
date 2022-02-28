import 'package:ia_bet/domain/repositories/firebase_repository.dart';

class SetUserTokenUseCase {
  final FirebaseRepository repository;

  SetUserTokenUseCase({required this.repository});

  Future<void> call(String token) async{
    repository.setUserToken(token);
  }
}
