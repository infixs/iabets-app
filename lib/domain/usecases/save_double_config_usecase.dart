import 'package:ia_bet/domain/repositories/firebase_repository.dart';

import '../../data/model/double_config_model.dart';

class SaveDoubleConfigUseCase {
  final FirebaseRepository repository;

  SaveDoubleConfigUseCase({required this.repository});

  Future<void> call(DoubleConfigModel doubleConfig) {
    return repository.saveDoubleConfig(doubleConfig);
  }
}
