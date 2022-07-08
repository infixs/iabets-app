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

class ResultRule {
  late ResultRuleOperator operator;
  late int position;
  bool relative = false;
  ResultRule({required this.operator, required this.position});

  ResultRule.fromJson(Map<String, dynamic> json) {
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

class ResultStrategyEntity {
  late List<StrategyColors> colors;
  List<ResultRule>? rules;

  ResultStrategyEntity({required this.colors, required this.rules});

  ResultStrategyEntity.fromJson(Map<String, dynamic> json) {
    colors = [];
    (json['colors'] as List).forEach((element) {
      if (element == 'red') {
        colors.add(StrategyColors.Red);
      } else if (element == 'black') {
        colors.add(StrategyColors.Black);
      } else if (element == 'white') {
        colors.add(StrategyColors.White);
      }
      rules =
          (json['rules'] as List).map((e) => ResultRule.fromJson(e)).toList();
    });
  }

  Map<String, dynamic> toJson() {
    final List<Map<String, dynamic>> rulesList = [];
    rules?.forEach((element) {
      rulesList.add(element.toJson());
    });

    return {'rules': rulesList, 'colors': []};
  }
}

class EntryStrategy {
  late StrategyColors colorTarget;
  late StrategyColors colorResult;

  EntryStrategy({required this.colorTarget, required this.colorResult});

  EntryStrategy.fromJson(Map<String, dynamic> json) {
    if (json['condition'] == 'red') {
      colorResult = StrategyColors.Red;
    } else if (json['condition'] == 'black') {
      colorResult = StrategyColors.Black;
    } else if (json['condition'] == 'white') {
      colorResult = StrategyColors.White;
    }

    if (json['target'] == 'red') {
      colorTarget = StrategyColors.Red;
    } else if (json['target'] == 'black') {
      colorTarget = StrategyColors.Black;
    } else if (json['target'] == 'white') {
      colorTarget = StrategyColors.White;
    }
  }

  Map<String, dynamic> toJson() {
    /* String target = '';
    String condition = '';
    if (colorTarget == StrategyColors.Red) {
      target = 'red';
    } else if (colorTarget == StrategyColors.Black) {
      target = 'black';
    } else if (colorTarget == StrategyColors.White) {
      target = 'white';
    }
    if (colorResult == StrategyColors.Red) {
      condition = 'red';
    } else if (colorTarget == StrategyColors.Black) {
      condition = 'black';
    } else if (colorTarget == StrategyColors.White) {
      condition = 'white';
    }

    return {'condition': condition, 'target': target};*/
    return {'condition': [], 'target': []};
  }
}
