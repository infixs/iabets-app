import '../../domain/entities/custom_strategy_entity.dart';

class CustomStrategyModel {
  final String name;
  final List<ResultStrategyEntity> resultStrategyEntities;
  final List<EntryStrategy> entryStrategies;

  CustomStrategyModel(
      {required this.resultStrategyEntities,
      required this.entryStrategies,
      required this.name});

  CustomStrategyModel.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        resultStrategyEntities = (json['sequences'] as List)
            .map((e) => ResultStrategyEntity.fromJson(e))
            .toList(),
        entryStrategies = (json['targets'] as List)
            .map((e) => EntryStrategy.fromJson(e))
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
