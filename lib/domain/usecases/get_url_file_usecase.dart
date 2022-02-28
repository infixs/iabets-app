import 'dart:typed_data';

import 'package:ia_bet/domain/repositories/firebase_repository.dart';

class GetUrlFileUseCase{
  final FirebaseRepository repository;

  GetUrlFileUseCase({required this.repository});

  Future<String> call(String canalName, String name)async{
    return await repository.getDownloadFileMessage(canalName, name);
  }
}