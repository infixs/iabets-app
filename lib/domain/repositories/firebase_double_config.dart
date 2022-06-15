abstract class FirebaseDoubleConfig {
  final int maxGales;
  final int maxElevation;

  final bool isActiveElevation; // AFTER (RED (SUPER LOSS));
  final bool isActiveStopGain;
  final bool isActiveStopLoss;

  final double amountStopGain;
  final double amountStopLoss;

  final List<_Strategies> strategies;
  final List<_Gales> gales;
  final List<int> elevations;

  const FirebaseDoubleConfig({
    required this.maxGales,
    required this.maxElevation,

    required this.isActiveElevation,
    required this.isActiveStopGain,
    required this.isActiveStopLoss,

    required this.amountStopGain,
    required this.amountStopLoss,

    required this.strategies,
    required this.gales,
    required this.elevations
  });
}

abstract class _Strategies {
  final String name;
  final bool active;
  const _Strategies({
    required this.name,
    required this.active,
  });
}

abstract class _Gales {
  // GALE
  final double amount; // DEFINED BY USER;
  final double amountProtection; // DEFINED BY USER;

  const _Gales({
    required this.amount,
    required this.amountProtection,
  });
}
