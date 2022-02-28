import 'dart:typed_data';

import 'package:ia_bet/domain/repositories/firebase_repository.dart';

class UploadFiletUseCase{
  final FirebaseRepository repository;

  UploadFiletUseCase({required this.repository});

  Future<void> call(String canalName, String name, Uint8List file)async{
    return await repository.uploadFileMessage(canalName, name, file);
  }
}