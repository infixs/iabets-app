import 'package:ia_bet/domain/entities/double_config.dart';
import 'package:ia_bet/domain/repositories/firebase_repository.dart';

class GetDoubleConfigUseCase {
  final FirebaseRepository repository;

  GetDoubleConfigUseCase({required this.repository});

  Stream<DoubleConfigEntity> call() {
    return repository.getDoubleConfig();
  }
}
