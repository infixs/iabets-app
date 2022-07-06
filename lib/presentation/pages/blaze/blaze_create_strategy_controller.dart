import 'package:flutter/widgets.dart';

class BlazeCreateStrategyController extends ChangeNotifier {
  final List<ResultStrategyEntity> strategyes = [];

  void add(ResultStrategyEntity value) {
    strategyes.add(value);
    notifyListeners();
  }
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

class ResultRule {
  final ResultRuleOperator operator;
  final int position;
  const ResultRule({required this.operator, required this.position});
}

class ResultStrategyEntity {
  final List<StrategyColors> colors;
  final List<ResultRule>? rules;
  const ResultStrategyEntity({required this.colors, required this.rules});
}
