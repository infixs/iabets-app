import 'package:ia_bet/domain/repositories/firebase_repository.dart';

class GetOneToOneSingleUserChatChannelUseCase {
  final FirebaseRepository repository;

  GetOneToOneSingleUserChatChannelUseCase({required this.repository});

  Future<String?> call(String uid, String canalName) async {
    return await repository.getOneToOneSingleUserChannelId(uid, canalName);
  }
}
