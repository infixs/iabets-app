class DoubleConfigEntity {
  final bool enabled;

  final int maxGales;
  final int maxElevation;

  final bool isActiveElevation; // AFTER (RED (SUPER LOSS));
  final bool isActiveStopGain;
  final bool isActiveStopLoss;

  final double amountStopGain;
  final double amountStopLoss;

  final List<Strategies> strategies;
  final List<Gales> gales;
  final List<int> elevations;

  const DoubleConfigEntity(
      {required this.enabled,
      required this.maxGales,
      required this.maxElevation,
      required this.isActiveElevation,
      required this.isActiveStopGain,
      required this.isActiveStopLoss,
      required this.amountStopGain,
      required this.amountStopLoss,
      required this.strategies,
      required this.gales,
      required this.elevations});
}

abstract class Strategies {
  final String id;
  final bool active;
  const Strategies({
    required this.id,
    required this.active,
  });
}

abstract class Gales {
  // GALE
  final double amount; // DEFINED BY USER;
  final double amountProtection; // DEFINED BY USER;

  const Gales({
    required this.amount,
    required this.amountProtection,
  });
}
