// API de autenticação

import 'package:flutter/foundation.dart';

import 'package:dio/dio.dart';
import 'package:ia_bet/domain/entities/user_entity.dart';

final BaseOptions options = BaseOptions(
    baseUrl: 'https://placar.iabetsoficial.com.br/api/user/login',
    connectTimeout: 10000,
    receiveTimeout: 30000,
    headers: {'Accept': 'application/json'});

late String apiToken;

Future<Response> getLogin(var userLogin) async {
  final Dio dio = Dio(options);
  final Response response = await dio.request(
    '',
    data: {"email": userLogin['email'], "password": userLogin['password']},
    options: Options(method: 'POST'),
  );
  apiToken = response.data['token'];
  debugPrint(response.toString());

  return response;
}

Future<List<Map<String, dynamic>>> getProducts(UserEntity user) async {
  final Dio dio = Dio();
  final List<Map<String, dynamic>> products = [];

  dio.options.headers["authorization"] = "Bearer ${user.apiToken}";

  final Response response =
      await dio.get('http://placar.iabetsoficial.com.br/api/v1/products');
  for (var element in (response.data as List)) {
    products.add(
        {'product': element['product'], 'created_at': element['created_at']});
  }

  return products;
}

Future<bool> resetPassword(String email) async {
  final Dio dio = Dio();

  try {
    final Response response = await dio.post(
        'http://placar.iabetsoficial.com.br/api/user/forgotpassword',
        data: {'email': email.trim()});

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  } catch (error, stackTrace) {
    debugPrint(error.toString());
    debugPrint(stackTrace.toString());
    return false;
  }
}
