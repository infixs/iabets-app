import 'package:ia_bet/domain/entities/text_message_entity.dart';
import 'package:ia_bet/domain/entities/user_entity.dart';
import 'package:ia_bet/domain/repositories/firebase_repository.dart';

class SendTextMessageUseCase{
  final FirebaseRepository repository;

  SendTextMessageUseCase({required this.repository});

  Future<void> sendTextMessage(TextMessageEntity textMessageEntity,String channelId, UserEntity allUsers)async{
    return await repository.sendTextMessage(textMessageEntity,channelId, allUsers);
  }

}