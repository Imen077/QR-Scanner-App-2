import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:ikutan/core/routes.dart';
import 'package:ikutan/models/user_model.dart';
import 'package:ikutan/providers/auth_provider.dart';
import 'package:ikutan/utils/const.dart';

class AuthServices extends GetxService {
  final AuthProvider _authProvider = Get.find<AuthProvider>();
  final _storage = FlutterSecureStorage();
  RxBool islogin = false.obs;
  Rx<User?> user = Rxn<User?>(null);

  @override
  void onInit() {
    super.onInit();
    init();
  }

  Future<String?> get token => _storage.read(key: Const.tokenKey);

  Future<void> saveToken({
    required String token,
    required User userData,
  }) async {
    await _storage.write(key: Const.tokenKey, value: token);
    user.value = userData;
    islogin(true);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: Const.tokenKey);
    user.value = null;
    islogin(false);
  }

  Future<void> init() async {
    final token = await this.token;
    if (token != null) {
      final res = await _authProvider.me();
      if (res.isOk) {
        user.value = User.fromJson(res.body);
        islogin(true);
        Future.delayed(
          const Duration(seconds: 2),
          () => Get.offAllNamed('AppRoutes.home'),
        );
      } else {
        await deleteToken();
        Future.delayed(
          const Duration(seconds: 2),
          () => Get.offAllNamed('AppRoutes.login'),
        );
      }
    }
  }

  Future<void> logout() async {
    await _authProvider.logout();
    await deleteToken();
    Get.offAllNamed(AppRoutes.login);
  }
}
