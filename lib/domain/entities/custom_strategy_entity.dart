import '../../data/model/entry_strategy_model.dart';
import '../../data/model/result_strategy_model.dart';

abstract class CustomStrategyEntity {
  late final String name;
  late final List<ResultStrategyModel> resultStrategyEntities;
  late final List<EntryStrategyModel> entryStrategies;
}

enum StrategyColors {
  Red('red'),
  Black('black'),
  White('white');

  const StrategyColors(this.value);
  final String value;
}

enum ResultRuleOperator {
  Equal('='),
  Different('!=');

  const ResultRuleOperator(this.value);
  final String value;
}
