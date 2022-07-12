import '../../domain/entities/custom_strategy_entity.dart';
import '../../domain/entities/result_strategy_entity.dart';

import 'result_rule_model.dart';

class ResultStrategyModel extends ResultStrategyEntity {
  ResultStrategyModel({required super.colors, required super.rules});

  factory ResultStrategyModel.fromJson(Map<String, dynamic> json) =>
      ResultStrategyModel(
        colors: (json['colors'] as List)
            .map((e) => e == 'red'
                ? StrategyColors.red
                : e == 'black'
                    ? StrategyColors.black
                    : StrategyColors.white)
            .toList(),
        rules: (json['rules'] as List)
            .map((e) => ResultRuleModel.fromJson(e))
            .toList(),
      );

  Map<String, dynamic> toJson() {
    final List<Map<String, dynamic>> rulesList = [];
    final List<String> colorsList = [];

    rules?.forEach((element) {
      rulesList.add(element.toJson());
    });

    for (StrategyColors element in colors) {
      if (element == StrategyColors.red) {
        colorsList.add('red');
      } else if (element == StrategyColors.black) {
        colorsList.add('black');
      } else if (element == StrategyColors.white) {
        colorsList.add('white');
      }
    }

    return {
      'rules': rulesList,
      'colors': colorsList,
    };
  }
}
