import '../../data/model/entry_strategy_model.dart';
import '../../data/model/result_strategy_model.dart';

abstract class CustomStrategyEntity {
  final String name;
  bool enabled;
  final List<ResultStrategyModel> resultStrategyEntities;
  final List<EntryStrategyModel> entryStrategies;

  CustomStrategyEntity(
      {required this.name,
      this.enabled = false,
      required this.resultStrategyEntities,
      required this.entryStrategies});
}

enum StrategyColors {
  red('red'),
  black('black'),
  white('white');

  const StrategyColors(this.value);
  final String value;
}

enum ResultRuleOperator {
  equal('='),
  different('!=');

  const ResultRuleOperator(this.value);
  final String value;
}
