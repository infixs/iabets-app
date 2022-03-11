import 'package:ia_bet/domain/repositories/firebase_repository.dart';

class DeleteMessagesUseCase {
  final FirebaseRepository repository;

  DeleteMessagesUseCase({required this.repository});

  Future<void> call(String channelId, List<String> messages) async {
    return repository.deleteMessages(channelId, messages);
  }
}
