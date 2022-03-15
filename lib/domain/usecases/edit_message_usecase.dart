import 'package:ia_bet/domain/repositories/firebase_repository.dart';

class EditMessageUseCase {
  final FirebaseRepository repository;

  EditMessageUseCase({required this.repository});

  Future<void> call(String channelId, String messageId, String messageText) async {
    return repository.editMessage(channelId, messageId, messageText);
  }
}
