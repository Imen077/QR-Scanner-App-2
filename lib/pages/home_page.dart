import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ikutan/controllers/nav_controller.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final _navController = Get.find<NavController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      body: Obx(
        () => IndexedStack(
          index: _navController.currentIndex.value,
          children: _navController.navItems.map((e) => e.screen).toList(),
        ),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: _navController.currentIndex.value,
          onTap: (value) {
            _navController.changeIndex(value);
          },
          items: _navController.navItems
              .map((e) => BottomNavigationBarItem(icon: e.icon, label: e.label))
              .toList(),
        ),
      ),
    );
  }
}
