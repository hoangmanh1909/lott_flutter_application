import 'package:mvc_pattern/mvc_pattern.dart';

import '../config/command_code.dart';
import '../core/api_client.dart';
import '../model/request/request_object.dart';

class ResultController extends ControllerMVC {
  factory ResultController() => _this ??= ResultController._();
  ResultController._();
  static ResultController? _this;
  final ApiClient _apiClient = ApiClient();

  Future<dynamic> getDrawKeno() async {
    RequestObject baseRequest = RequestObject(
        code: CommandCode.DIC_GET_DRAW_KENO, data: "", signature: "");
    return await _apiClient.execute(baseRequest);
  }
}
