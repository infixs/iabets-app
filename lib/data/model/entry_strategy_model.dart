import '../../domain/entities/custom_strategy_entity.dart';
import '../../domain/entities/entry_strategy_entity.dart';

class EntryStrategyModel extends EntryStrategyEntity {
  EntryStrategyModel({required super.colorTarget, required super.colorResult});

  factory EntryStrategyModel.fromJson(Map<String, dynamic> json) =>
      EntryStrategyModel(
        colorResult: (json['condition'] == 'red')
            ? StrategyColors.red
            : (json['condition'] == 'black'
                ? StrategyColors.black
                : StrategyColors.white),
        colorTarget: (json['target'] == 'red')
            ? StrategyColors.red
            : (json['target'] == 'black'
                ? StrategyColors.black
                : StrategyColors.white),
      );

  Map<String, dynamic> toJson() {
    late String target;
    late String condition;
    if (colorTarget == StrategyColors.red) {
      target = 'red';
    } else if (colorTarget == StrategyColors.black) {
      target = 'black';
    } else if (colorTarget == StrategyColors.white) {
      target = 'white';
    }
    if (colorResult == StrategyColors.red) {
      condition = 'red';
    } else if (colorTarget == StrategyColors.black) {
      condition = 'black';
    } else if (colorTarget == StrategyColors.white) {
      condition = 'white';
    }

    return {'condition': condition, 'target': target};
  }
}
