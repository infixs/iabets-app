import 'package:ia_bet/domain/entities/user_entity.dart';
import 'package:ia_bet/domain/repositories/firebase_repository.dart';

class GetCurrentUserUseCase{
  final FirebaseRepository repository;

  GetCurrentUserUseCase({required this.repository});

  Stream<UserEntity> call(){
    return repository.getCurrentUser();
  }

}