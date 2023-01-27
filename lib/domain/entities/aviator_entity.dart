abstract class AviatorEntity {
  final String orientationSignal;
  final String status;
  final String titleSignal;
  final bool waiting;

  AviatorEntity(
      {required this.orientationSignal,
      required this.status,
      required this.titleSignal,
      required this.waiting});
}
