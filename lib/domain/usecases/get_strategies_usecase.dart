import 'package:ia_bet/domain/entities/strategy_entity.dart';
import 'package:ia_bet/domain/repositories/firebase_repository.dart';

class GetStrategiesUseCase {
  final FirebaseRepository repository;

  GetStrategiesUseCase({required this.repository});

  Future<List<StrategyEntity>> call() {
    return repository.getStrategies();
  }
}
