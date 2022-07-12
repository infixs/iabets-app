import 'custom_strategy_entity.dart';

abstract class EntryStrategyEntity {
  final StrategyColors colorTarget;
  final StrategyColors colorResult;

  EntryStrategyEntity({required this.colorTarget, required this.colorResult});
}
