import 'custom_strategy_entity.dart';

abstract class ResultRuleEntity {
  late ResultRuleOperator operator;
  late int position;
  bool relative = false;
}
