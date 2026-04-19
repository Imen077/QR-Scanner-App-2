import 'package:get/get.dart';
import 'package:ikutan/services/auth_services.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthServices(), permanent: true);
  }
}