import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ia_bet/data/model/custom_strategy_model.dart';
import 'package:ia_bet/domain/entities/double_config.dart';

class DoubleConfigModel extends DoubleConfigEntity {
  DoubleConfigModel({
    required super.enabled,
    required super.isActiveGale,
    required super.isActiveStopGain,
    required super.isActiveStopLoss,
    required super.wallet,
    required super.amountStopGain,
    required super.amountStopLoss,
    required super.maxGales,
    required super.maxElevation,
    required super.gales,
    required super.elevations,
    required super.isActiveElevation,
    required super.strategies,
    required super.entryAmount,
    required super.entryWhiteAmount,
    required super.customStrategies,
  });

  factory DoubleConfigModel.fromSnapshot(DocumentSnapshot snapshot) {
    final Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    return DoubleConfigModel(
      enabled: data['enabled'],
      isActiveStopGain: data['isActiveStopGain'],
      isActiveStopLoss: data['isActiveStopLoss'],
      isActiveGale: data['isActiveGale'],
      amountStopGain: (data['amountStopGain'] is int)
          ? (data['amountStopGain'] as int).toDouble()
          : data['amountStopGain'],
      amountStopLoss: (data['amountStopLoss'] is int)
          ? (data['amountStopLoss'] as int).toDouble()
          : data['amountStopLoss'],
      maxGales: data['maxGales'],
      maxElevation: data['maxElevation'],
      gales: (data['gales'] as List).map((e) => Gale.fromJson(e)).toList(),
      elevations: List<int>.from(data['elevations']),
      isActiveElevation: data['isActiveElevation'],
      strategies: (data['strategies'] as List)
          .map((e) => Strategy.fromJson(e))
          .toList(),
      wallet: (data['wallet'] is int)
          ? (data['wallet'] as int).toDouble()
          : data['wallet'],
      entryAmount: (data['entryAmount'] is int)
          ? (data['entryAmount'] as int).toDouble()
          : data['entryAmount'],
      entryWhiteAmount: (data['entryWhiteAmount'] is int)
          ? (data['entryWhiteAmount'] as int).toDouble()
          : data['entryWhiteAmount'],
      customStrategies: (data['customStrategies'] as List)
          .map((e) => CustomStrategyModel.fromJson(e))
          .toList(),
    );
  }

  factory DoubleConfigModel.createDefault() {
    return DoubleConfigModel(
      amountStopGain: 0,
      amountStopLoss: 0,
      elevations: [],
      enabled: false,
      gales: [],
      isActiveElevation: false,
      isActiveStopGain: false,
      isActiveStopLoss: false,
      isActiveGale: false,
      maxElevation: 0,
      maxGales: 3,
      strategies: [],
      wallet: 0,
      entryAmount: 0,
      entryWhiteAmount: 0,
      customStrategies: [],
    );
  }

  Map<String, dynamic> toDocument() {
    final List<Map<String, dynamic>> galesList = [];
    for (Gale element in gales) {
      galesList.add(element.toJson());
    }

    final List<Map<String, dynamic>> strategiesList = [];
    for (Strategy element in strategies) {
      strategiesList.add(element.toJson());
    }
    final List<Map<String, dynamic>> customStrategiesList = [];
    for (CustomStrategyModel element in customStrategies) {
      customStrategiesList.add(element.toJson());
    }

    return {
      'enabled': enabled,
      'isActiveStopGain': isActiveStopGain,
      'isActiveStopLoss': isActiveStopLoss,
      'amountStopGain': amountStopGain,
      'amountStopLoss': amountStopLoss,
      'maxGales': maxGales,
      'maxElevation': maxElevation,
      'gales': galesList,
      'elevations': elevations,
      'isActiveElevation': isActiveElevation,
      'isActiveGale': isActiveGale,
      'strategies': strategiesList,
      'entryAmount': entryAmount,
      'entryWhiteAmount': entryWhiteAmount,
      'customStrategies': customStrategiesList,
    };
  }
}
