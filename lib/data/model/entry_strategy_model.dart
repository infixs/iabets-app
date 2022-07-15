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

  Map<String, dynamic> toJson() => {
        'condition': (colorResult == StrategyColors.red)
            ? 'red'
            : (colorResult == StrategyColors.black)
                ? 'black'
                : 'white',
        'target': (colorTarget == StrategyColors.red)
            ? 'red'
            : (colorTarget == StrategyColors.black)
                ? 'black'
                : 'white'
      };
}
