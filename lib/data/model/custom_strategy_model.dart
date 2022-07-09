import '../../domain/entities/custom_strategy_entity.dart';
import 'entry_strategy_model.dart';
import 'result_strategy_model.dart';

class CustomStrategyModel extends CustomStrategyEntity {
  final String name;
  final List<ResultStrategyModel> resultStrategyEntities;
  final List<EntryStrategyModel> entryStrategies;

  CustomStrategyModel(
      {required this.resultStrategyEntities,
      required this.entryStrategies,
      required this.name});

  CustomStrategyModel.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        resultStrategyEntities = (json['sequences'] as List)
            .map((e) => ResultStrategyModel.fromJson(e))
            .toList(),
        entryStrategies = (json['targets'] as List)
            .map((e) => EntryStrategyModel.fromJson(e))
            .toList();

  Map<String, dynamic> toJson() {
    final List<Map<String, dynamic>> resultStrategyEntitiesList = [];
    resultStrategyEntities.forEach((element) {
      resultStrategyEntitiesList.add(element.toJson());
    });

    final List<Map<String, dynamic>> entryStrategiesList = [];
    entryStrategies.forEach((element) {
      entryStrategiesList.add(element.toJson());
    });

    return {
      'name': name,
      'sequences': resultStrategyEntitiesList,
      'targets': entryStrategiesList,
    };
  }
}
