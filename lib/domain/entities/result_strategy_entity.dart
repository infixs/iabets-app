import '../../data/model/result_rule_model.dart';

import 'custom_strategy_entity.dart';

abstract class ResultStrategyEntity {
  final List<StrategyColors> colors;
  final List<ResultRuleModel>? rules;

  ResultStrategyEntity({required this.colors, required this.rules});
}
