abstract class CrashEntity {
  final String orientationSignal;
  final String status;
  final String titleSignal;
  final bool waiting;

  CrashEntity(
      {required this.orientationSignal,
      required this.status,
      required this.titleSignal,
      required this.waiting});
}
