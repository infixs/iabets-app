// API de autenticação

import 'package:dio/dio.dart';

var options = BaseOptions(
  baseUrl: 'https://placar.iabetsoficial.com.br/api/user/login',
  connectTimeout: 10000,
  receiveTimeout: 30000,
  headers: {
    'Accept':'application/json'
  }
);
Dio dio = Dio(options);


Future<Response> getLogin(var userLogin) async{

  Response response = await dio.request(
    '',
    data: {"email":userLogin['email'], "password": userLogin['password'] },
    options: Options(method:'POST'),
  );

  print(response);


  return response;
}
