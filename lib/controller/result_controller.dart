import 'dart:convert';

import 'package:lott_flutter_application/model/request/draw_result_request.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../config/command_code.dart';
import '../core/api_client.dart';
import '../model/request/request_object.dart';

class ResultController extends ControllerMVC {
  factory ResultController() => _this ??= ResultController._();
  ResultController._();
  static ResultController? _this;
  final ApiClient _apiClient = ApiClient();

  Future<dynamic> getDrawResult(DrawResultRequest req) async {
    RequestObject baseRequest = RequestObject(
        code: CommandCode.DRAW_RESULT_SEARCH,
        data: jsonEncode(req),
        signature: "cfa55b55ecead97653a915b788eefb8b");
    return await _apiClient.execute(baseRequest);
  }

  Future<dynamic> getDrawKeno() async {
    RequestObject baseRequest = RequestObject(
        code: CommandCode.DIC_GET_DRAW_KENO_V1,
        data: "",
        signature: "cfa55b55ecead97653a915b788eefb8b");
    return await _apiClient.execute(baseRequest);
  }

  Future<dynamic> getResultKeno() async {
    RequestObject baseRequest = RequestObject(
        code: CommandCode.RESULT_KENO,
        data: "",
        signature: "cfa55b55ecead97653a915b788eefb8b");
    return await _apiClient.execute(baseRequest);
  }

  Future<dynamic> getResultMega() async {
    RequestObject baseRequest = RequestObject(
        code: CommandCode.RESULT_MEGA,
        data: "",
        signature: "cfa55b55ecead97653a915b788eefb8b");
    return await _apiClient.execute(baseRequest);
  }

  Future<dynamic> getResultPower() async {
    RequestObject baseRequest = RequestObject(
        code: CommandCode.RESULT_POWER,
        data: "",
        signature: "cfa55b55ecead97653a915b788eefb8b");
    return await _apiClient.execute(baseRequest);
  }

  Future<dynamic> getResultMax3D() async {
    RequestObject baseRequest = RequestObject(
        code: CommandCode.RESULT_MAX3D,
        data: "",
        signature: "cfa55b55ecead97653a915b788eefb8b");
    return await _apiClient.execute(baseRequest);
  }

  Future<dynamic> getResultMax3DPro() async {
    RequestObject baseRequest = RequestObject(
        code: CommandCode.RESULT_MAX3D_PRO,
        data: "",
        signature: "cfa55b55ecead97653a915b788eefb8b");
    return await _apiClient.execute(baseRequest);
  }

  Future<dynamic> getResultMB() async {
    RequestObject baseRequest = RequestObject(
        code: CommandCode.RESULT_LOTOMB,
        data: "",
        signature: "cfa55b55ecead97653a915b788eefb8b");
    return await _apiClient.execute(baseRequest);
  }

  Future<dynamic> getPrams() async {
    RequestObject baseRequest = RequestObject(
        code: CommandCode.DIC_GET_PARAMS,
        data: "",
        signature: "cfa55b55ecead97653a915b788eefb8b");
    return await _apiClient.execute(baseRequest);
  }
}
