import 'package:ia_bet/domain/entities/double_config.dart';
import 'package:ia_bet/domain/repositories/firebase_repository.dart';

class SaveDoubleConfigUseCase {
  final FirebaseRepository repository;

  SaveDoubleConfigUseCase({required this.repository});

  Future<void> call(DoubleConfigEntity doubleConfig) {
    return repository.saveDoubleConfig(doubleConfig);
  }
}
