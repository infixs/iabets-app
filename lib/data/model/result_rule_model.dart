import '../../domain/entities/custom_strategy_entity.dart';
import '../../domain/entities/result_rule_entity.dart';

class ResultRuleModel extends ResultRuleEntity {
  ResultRuleModel({required super.operator, required super.position});

  factory ResultRuleModel.fromJson(Map<String, dynamic> json) =>
      ResultRuleModel(
          position: json['position'],
          operator: (json['operator'] == '=')
              ? ResultRuleOperator.equal
              : ResultRuleOperator.different);

  Map<String, dynamic> toJson() {
    String operatorText = '';
    if (operator == ResultRuleOperator.equal) {
      operatorText = '=';
    } else if (operator == ResultRuleOperator.different) {
      operatorText = '!=';
    }

    return {
      'operator': operatorText,
      'position': position,
      'relative': relative
    };
  }
}
