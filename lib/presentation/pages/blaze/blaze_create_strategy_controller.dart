import 'package:flutter/widgets.dart';

import '../../../domain/entities/custom_strategy_entity.dart';

class BlazeCreateStrategyController extends ChangeNotifier {
  final List<ResultStrategyEntity> strategyes = [];

  void add(ResultStrategyEntity value) {
    strategyes.add(value);
    notifyListeners();
  }
}
