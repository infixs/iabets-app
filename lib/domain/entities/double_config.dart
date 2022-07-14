import '../../data/model/custom_strategy_model.dart';

class DoubleConfigEntity {
  final bool enabled;

  final int maxGales;
  final int maxElevation;

  final bool isActiveGale;
  final bool isActiveElevation; // AFTER (RED (SUPER LOSS));
  final bool isActiveStopGain;
  final bool isActiveStopLoss;
  bool stopWithWhite;

  final double amountStopGain;
  final double amountStopLoss;
  final double? wallet;

  final double entryAmount;
  final double entryWhiteAmount;

  List<Strategy> strategies;
  final List<Gale> gales;
  final List<int> elevations;

  final List<CustomStrategyModel> customStrategies;

  DoubleConfigEntity({
    required this.enabled,
    required this.maxGales,
    required this.maxElevation,
    required this.isActiveElevation,
    required this.isActiveGale,
    required this.isActiveStopGain,
    required this.isActiveStopLoss,
    required this.amountStopGain,
    required this.amountStopLoss,
    required this.strategies,
    required this.gales,
    required this.elevations,
    required this.wallet,
    required this.entryAmount,
    required this.entryWhiteAmount,
    required this.customStrategies,
    required this.stopWithWhite,
  });
}

class Strategy {
  final String id;
  final String name;
  bool active;

  Strategy.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        active = json['active'],
        name = json['name'];

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'active': active};

  Strategy({
    required this.name,
    required this.id,
    required this.active,
  });
}

class Gale {
  // GALE
  final double amount; // DEFINED BY USER;
  final double amountProtection; // DEFINED BY USER;

  Gale.fromJson(Map<String, dynamic> json)
      : amount = (json['amount'] is int)
            ? (json['amount'] as int).toDouble()
            : json['amount'],
        amountProtection = (json['amountProtection'] is int)
            ? (json['amountProtection'] as int).toDouble()
            : json['amountProtection'];

  Map<String, dynamic> toJson() =>
      {'amount': amount, 'amountProtection': amountProtection};

  const Gale({
    required this.amount,
    required this.amountProtection,
  });
}
