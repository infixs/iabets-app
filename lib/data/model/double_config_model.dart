import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ia_bet/domain/entities/double_config.dart';

class DoubleConfigModel extends DoubleConfigEntity {
  const DoubleConfigModel({
    required bool enabled,
    required bool isActiveGale,
    required bool isActiveStopGain,
    required bool isActiveStopLoss,
    required double? wallet,
    required double amountStopGain,
    required double amountStopLoss,
    required int maxGales,
    required int maxElevation,
    required List<Gale> gales,
    required List<int> elevations,
    required bool isActiveElevation,
    required List<Strategy> strategies,
    required double entryAmount,
    required double entryWhiteAmount,
  }) : super(
          wallet: wallet,
          enabled: enabled,
          isActiveGale: isActiveGale,
          isActiveStopGain: isActiveStopGain,
          isActiveStopLoss: isActiveStopLoss,
          amountStopGain: amountStopGain,
          amountStopLoss: amountStopLoss,
          maxGales: maxGales,
          maxElevation: maxElevation,
          gales: gales,
          elevations: elevations,
          isActiveElevation: isActiveElevation,
          strategies: strategies,
          entryAmount: entryAmount,
          entryWhiteAmount: entryWhiteAmount,
        );

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
    );
  }

  Map<String, dynamic> toDocument() {
    final List<Map<String, dynamic>> galesList = [];
    gales.forEach((element) {
      galesList.add(element.toJson());
    });

    final List<Map<String, dynamic>> strategiesList = [];
    strategies.forEach((element) {
      strategiesList.add(element.toJson());
    });

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
    };
  }
}
