import 'custom_strategy_entity.dart';

abstract class ResultRuleEntity {
  final ResultRuleOperator operator;
  final int position;
  bool relative = false;

  ResultRuleEntity({required this.operator, required this.position});
}
