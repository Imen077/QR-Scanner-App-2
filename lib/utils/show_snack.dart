import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShowSnack {
  static void info(String message) {
    Get.snackbar(
      'Info',
      message,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
    );
  }
  static void error(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
      colorText: Colors.white,
      backgroundColor: Colors.red.shade900,
    );
  }
  static void success(String message) {
    Get.snackbar(
      'Success',
      message,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
      colorText: Colors.white,
      backgroundColor: Colors.green.shade900,
    );
  }
  static void warning(String message) {
    Get.snackbar(
      'Warning',
      message,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
      colorText: Colors.white,
      backgroundColor: Colors.yellow.shade900,
    );
  }
}
