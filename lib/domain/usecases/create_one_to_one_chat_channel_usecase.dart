
import 'package:ia_bet/domain/entities/user_entity.dart';
import 'package:ia_bet/domain/repositories/firebase_repository.dart';

class CreateOneToOneChatChannelUseCase{
  final FirebaseRepository repository;

  CreateOneToOneChatChannelUseCase({required this.repository});

  Future<void> call(String uid, List<UserEntity> allUsers, String name)async{
    return repository.createOneToOneChatChannel(uid, name, allUsers);
  }
}