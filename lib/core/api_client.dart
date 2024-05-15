// ignore_for_file: deprecated_member_use, prefer_interpolation_to_compose_strings

import 'dart:io';

import 'package:dio/dio.dart';

import '../config/api.dart';
import '../model/request/request_object.dart';
import '../model/response/response_object.dart';

class ApiClient {
  final Dio _dio = Dio();

  Future<ResponseObject> execute(RequestObject baseRequest) async {
    try {
      Response response = await _dio.post(urlGateway + "Gateway/ExecuteV1",
          data: baseRequest,
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          }));

      return ResponseObject.fromJson(response.data);
    } on DioError {
      ResponseObject responseObject =
          ResponseObject(code: "98", message: "Không thể kết nối đến máy chủ");
      return responseObject;
    }
  }
}
