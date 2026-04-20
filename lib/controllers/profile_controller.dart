import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ikutan/models/user_model.dart';
import 'package:ikutan/services/auth_services.dart';
import 'package:ikutan/utils/show_snack.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  final AuthServices _authServices = Get.find<AuthServices>();

  RxBool isLoading = false.obs;
  Rx<File?> pickedImage = Rx<File?>(null);

  // Form controllers
  late TextEditingController nameCtr;
  late TextEditingController emailCtr;
  late TextEditingController phoneCtr;

  RxString selectedLanguage = 'English'.obs;
  RxString selectedCurrency = 'USD'.obs;
  RxBool appLockEnabled = false.obs;
  RxBool biometricEnabled = false.obs;
  RxString selectedTheme = 'Dark'.obs;
  RxList<Map<String, String>> devices = <Map<String, String>>[
    {'name': 'iPhone 14', 'location': 'Jakarta, ID', 'active': 'true'},
    {'name': 'Chrome on Windows', 'location': 'Bandung, ID', 'active': 'false'},
  ].obs;

  User? get user => _authServices.user.value;

  @override
  void onInit() {
    super.onInit();
    _initControllers();
  }

  void _initControllers() {
    nameCtr = TextEditingController(text: user?.name ?? '');
    emailCtr = TextEditingController(text: user?.email ?? '');
    phoneCtr = TextEditingController(text: user?.phone ?? '');
  }

  @override
  void onClose() {
    nameCtr.dispose();
    emailCtr.dispose();
    phoneCtr.dispose();
    super.onClose();
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 800,
      );
      if (picked != null) {
        pickedImage.value = File(picked.path);
      }
    } catch (e) {
      ShowSnack.error('Failed to pick image: $e');
    }
  }

  void removeImage() {
    pickedImage.value = null;
  }

  Future<void> saveProfile() async {
    isLoading(true);
    try {
      await Future.delayed(const Duration(milliseconds: 800));

      final updatedUser = _authServices.user.value?.copyWith(
        name: nameCtr.text.trim(),
        phone: phoneCtr.text.trim(),
      );

      if (updatedUser != null) {
        _authServices.user.value = updatedUser;
      }

      ShowSnack.success('Profile updated successfully!');
      Get.back();
    } catch (e) {
      ShowSnack.error('Failed to update: $e');
    } finally {
      isLoading(false);
    }
  }

  void resetForm() {
    nameCtr.text = user?.name ?? '';
    emailCtr.text = user?.email ?? '';
    phoneCtr.text = user?.phone ?? '';
    pickedImage.value = null;
  }

  void setLanguage(String lang) => selectedLanguage.value = lang;
  void setCurrency(String cur) => selectedCurrency.value = cur;
  void setTheme(String theme) => selectedTheme.value = theme;
  void toggleAppLock(bool val) => appLockEnabled.value = val;
  void toggleBiometric(bool val) => biometricEnabled.value = val;

  void removeDevice(int index) {
    devices.removeAt(index);
    ShowSnack.success('Device removed');
  }
}
