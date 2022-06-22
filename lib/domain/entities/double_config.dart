class DoubleConfigEntity {
  final bool enabled;

  final int maxGales;
  final int maxElevation;

  final bool isActiveElevation; // AFTER (RED (SUPER LOSS));
  final bool isActiveStopGain;
  final bool isActiveStopLoss;

  final double amountStopGain;
  final double amountStopLoss;
  final double wallet;

  final double entryAmount;
  final double entryWhiteAmount;

  final List<Strategies> strategies;
  final List<Gales> gales;
  final List<int> elevations;

  const DoubleConfigEntity({
    required this.enabled,
    required this.maxGales,
    required this.maxElevation,
    required this.isActiveElevation,
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
  });
}

class Strategies {
  final String id;
  final bool active;

  Strategies.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        active = json['active'];

  const Strategies({
    required this.id,
    required this.active,
  });
}

class Gales {
  // GALE
  final double amount; // DEFINED BY USER;
  final double amountProtection; // DEFINED BY USER;

  Gales.fromJson(Map<String, dynamic> json)
      : amount = (json['amount'] as int).toDouble(),
        amountProtection = (json['amountProtection'] as int).toDouble();

  const Gales({
    required this.amount,
    required this.amountProtection,
  });
}
