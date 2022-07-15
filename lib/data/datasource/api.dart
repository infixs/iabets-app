// API de autenticação

import 'package:flutter/foundation.dart';

import 'package:dio/dio.dart';
import 'package:ia_bet/domain/entities/user_entity.dart';

final BaseOptions options = BaseOptions(
    baseUrl: 'https://placar.iabetsoficial.com.br/api/user/login',
    connectTimeout: 10000,
    receiveTimeout: 30000,
    headers: {'Accept': 'application/json'});

late final String apiToken;

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

Future<List> getProducts(UserEntity user) async {
  final Dio dio = Dio();
  final List<String> listProductsId = [];

  dio.options.headers["authorization"] = "Bearer ${user.apiToken}";

  final Response response =
      await dio.get('http://placar.iabetsoficial.com.br/api/v1/products');
  for (var element in (response.data as List)) {
    listProductsId.add(element['product']);
  }
  return listProductsId;
}
