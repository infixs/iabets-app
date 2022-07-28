import 'package:flutter/widgets.dart';

import '../../../data/model/result_strategy_model.dart';

class BlazeCreateStrategyController extends ChangeNotifier {
  final List<ResultStrategyModel> strategyes = [];

  void add(ResultStrategyModel value) {
    strategyes.add(value);
    notifyListeners();
  }
}
