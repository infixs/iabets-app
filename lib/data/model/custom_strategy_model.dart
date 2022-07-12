import '../../domain/entities/custom_strategy_entity.dart';

import 'entry_strategy_model.dart';
import 'result_strategy_model.dart';

class CustomStrategyModel extends CustomStrategyEntity {
  CustomStrategyModel(
      {required super.resultStrategyEntities,
      required super.entryStrategies,
      required super.name});

  factory CustomStrategyModel.fromJson(Map<String, dynamic> json) =>
      CustomStrategyModel(
          resultStrategyEntities: (json['sequences'] as List)
              .map((e) => ResultStrategyModel.fromJson(e))
              .toList(),
          entryStrategies: (json['targets'] as List)
              .map((e) => EntryStrategyModel.fromJson(e))
              .toList(),
          name: json['name']);

  Map<String, dynamic> toJson() {
    final List<Map<String, dynamic>> resultStrategyEntitiesList = [];
    for (ResultStrategyModel element in resultStrategyEntities) {
      resultStrategyEntitiesList.add(element.toJson());
    }

    final List<Map<String, dynamic>> entryStrategiesList = [];
    for (EntryStrategyModel element in entryStrategies) {
      entryStrategiesList.add(element.toJson());
    }

    return {
      'name': name,
      'sequences': resultStrategyEntitiesList,
      'targets': entryStrategiesList,
    };
  }
}
