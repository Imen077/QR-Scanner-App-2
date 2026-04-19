import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ikutan/models/nav_item.dart';
import 'package:ikutan/pages/nav/events_tab.dart';
import 'package:ikutan/pages/nav/main_tab.dart';
import 'package:ikutan/pages/nav/my_tickets_tab.dart';
import 'package:ikutan/pages/nav/profile_tab.dart';
import 'package:ikutan/services/auth_services.dart';

class NavController extends GetxController {
  final AuthServices _authServices = Get.find();
  RxInt currentIndex = 0.obs;

  late List<NavItem> navItems;

  @override
  void onInit() {
    super.onInit();
    final NavItem roleBasedNav = _authServices.user.value!.role == 'attende'
        ? NavItem(
            label: 'My Tickets',
            icon: Icon(Icons.confirmation_num),
            screen: MyTicketsTab(),
          )
        : NavItem(
            label: 'Events',
            icon: Icon(Icons.campaign),
            screen: EventsTab(),
          );
    navItems = [
      NavItem(label: 'Home', icon: Icon(Icons.home), screen: MainTab()),
      roleBasedNav,
      NavItem(label: 'Profile', icon: Icon(Icons.person), screen: ProfileTab()),
    ];
  }

  void changeIndex(int index) {
    currentIndex.value = index;
  }
}
