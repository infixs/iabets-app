import 'package:dio/dio.dart';

class CrashRepository {
  final Dio _dio = Dio();

  Future<Response> getSignal() async =>
      _dio.get('http://robocrashvip.online/get-signal.php');

  Future<Response> getChance() async =>
      _dio.get('http://robocrashvip.online/get-chance.php');
}
