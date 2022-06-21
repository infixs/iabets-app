import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ia_bet/domain/entities/double_config.dart';

class DoubleConfigModel extends DoubleConfigEntity {
  DoubleConfigModel({
    required bool enabled,
    required bool isActiveStopGain,
    required bool isActiveStopLoss,
    required double amountStopGain,
    required double amountStopLoss,
    required int maxGales,
    required int maxElevation,
    required List<Gales> gales,
    required List<int> elevations,
    required bool isActiveElevation,
    required List<Strategies> strategies,
  }) : super(
          enabled: enabled,
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
        );

  factory DoubleConfigModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    return DoubleConfigModel(
      enabled: data['enabled'],
      isActiveStopGain: data['isActiveStopGain'],
      isActiveStopLoss: data['isActiveStopLoss'],
      amountStopGain: data['amountStopGain'],
      amountStopLoss: data['amountStopLoss'],
      maxGales: data['maxGales'],
      maxElevation: data['maxElevation'],
      gales: data['gales'],
      elevations: data['elevations'],
      isActiveElevation: data['isActiveElevation'],
      strategies: data['strategies'],
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
      maxElevation: 0,
      maxGales: 3,
      strategies: [],
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'enabled': enabled,
      'isActiveStopGain': isActiveStopGain,
      'isActiveStopLoss': isActiveStopLoss,
      'amountStopGain': amountStopGain,
      'amountStopLoss': amountStopLoss,
      'maxGales': maxGales,
      'maxElevation': maxElevation,
      'gales': gales,
      'elevations': elevations,
      'isActiveElevation': isActiveElevation,
      'strategies': strategies,
    };
  }
}
