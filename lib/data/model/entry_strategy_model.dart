import '../../domain/entities/custom_strategy_entity.dart';
import '../../domain/entities/entry_strategy_entity.dart';

class EntryStrategyModel extends EntryStrategyEntity {
  late StrategyColors colorTarget;
  late StrategyColors colorResult;

  EntryStrategyModel({required this.colorTarget, required this.colorResult});

  EntryStrategyModel.fromJson(Map<String, dynamic> json) {
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
    String target = '';
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

    return {'condition': condition, 'target': target};
  }
}
