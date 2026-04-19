import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:ikutan/env/env.dart';
import 'package:ikutan/utils/const.dart';

class ApiProvider extends GetConnect {
  final _storage = FlutterSecureStorage();
  @override
  void onInit() {
    httpClient.baseUrl = Const.baseUrlApi;
    httpClient.addRequestModifier<dynamic>((request) async {
      final token = await _storage.read(key: Const.tokenKey);
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      request.headers['Content-Type'] = 'application/json';
      request.headers['Accept'] = 'application/json';
      request.headers['X-API-Key'] = Env.apiKey;
      return request;
    });
    super.onInit();
  }
}
