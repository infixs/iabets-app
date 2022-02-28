import 'package:ia_bet/domain/entities/my_chat_entity.dart';
import 'package:ia_bet/domain/entities/user_entity.dart';
import 'package:ia_bet/domain/repositories/firebase_repository.dart';

class AddToMyChatUseCase{
  final FirebaseRepository repository;

  AddToMyChatUseCase({required this.repository});

  Future<void> call(MyChatEntity myChatEntity, UserEntity allUsers)async{
    return await repository.addToMyChat(myChatEntity, allUsers);
  }
}