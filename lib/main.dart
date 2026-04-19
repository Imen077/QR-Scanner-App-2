import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ikutan/core/routes.dart';
import 'package:ikutan/core/themes.dart';
import 'package:ikutan/services/auth_services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  Get.put(AuthServices());
  Get.put(AuthServices());
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // initialBinding: AppBinding(),
      theme: AppThemes.dark,
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.initialRoute,
      getPages: AppRoutes.pages,
    );
  }
}
