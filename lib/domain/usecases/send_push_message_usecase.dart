import 'package:ia_bet/domain/repositories/firebase_repository.dart';

class SendPushMessageUseCase{
  final FirebaseRepository repository;

  SendPushMessageUseCase({required this.repository});

  Future<void> call(String channelId, String title, String message){
    return repository.sendPushMessage(channelId, title, message);
  }
}