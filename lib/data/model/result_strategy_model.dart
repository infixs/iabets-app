import '../../domain/entities/custom_strategy_entity.dart';

import '../../domain/entities/result_strategy_entity.dart';
import 'result_rule_model.dart';

class ResultStrategyModel extends ResultStrategyEntity {
  late List<StrategyColors> colors;
  late List<ResultRuleModel>? rules;

  ResultStrategyModel({required this.colors, required this.rules});

  ResultStrategyModel.fromJson(Map<String, dynamic> json) {
    colors = [];
    (json['colors'] as List).forEach((element) {
      if (element == 'red') {
        colors.add(StrategyColors.Red);
      } else if (element == 'black') {
        colors.add(StrategyColors.Black);
      } else if (element == 'white') {
        colors.add(StrategyColors.White);
      }
      rules = (json['rules'] as List)
          .map((e) => ResultRuleModel.fromJson(e))
          .toList();
    });
  }

  Map<String, dynamic> toJson() {
    final List<Map<String, dynamic>> rulesList = [];
    final List<String> colorsList = [];

    rules?.forEach((element) {
      rulesList.add(element.toJson());
    });

    colors.forEach((element) {
      if (element == StrategyColors.Red) {
        colorsList.add('red');
      } else if (element == StrategyColors.Black) {
        colorsList.add('black');
      } else if (element == StrategyColors.White) {
        colorsList.add('white');
      }
    });

    return {
      'rules': rulesList,
      'colors': colorsList,
    };
  }
}
