import '../../domain/entities/custom_strategy_entity.dart';
import '../../domain/entities/result_rule_entity.dart';

class ResultRuleModel extends ResultRuleEntity {
  late ResultRuleOperator operator;
  late int position;
  bool relative = false;
  ResultRuleModel({required this.operator, required this.position});

  ResultRuleModel.fromJson(Map<String, dynamic> json) {
    position = json['position'];

    if (json['operator'] == '=') {
      operator = ResultRuleOperator.Equal;
    } else if (json['operator'] == '!=') {
      operator = ResultRuleOperator.Different;
    }
  }

  Map<String, dynamic> toJson() {
    String operatorText = '';
    if (operator == ResultRuleOperator.Equal) {
      operatorText = '=';
    } else if (operator == ResultRuleOperator.Different) {
      operatorText = '!=';
    }

    return {
      'operator': operatorText,
      'position': position,
      'relative': relative
    };
  }
}
