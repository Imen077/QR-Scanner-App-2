import 'package:get/get.dart';

class Validator {
  static String? validateEmail(String? value) {
    if (!GetUtils.isEmail(value!)) {
      return 'Please enter a valid email';
    }
    return null;
  } 

  static String ? validatePassword(String? value) {
    if (value!.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value!.length < 3) {
      return 'Name must be at least 3 characters';
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }
}