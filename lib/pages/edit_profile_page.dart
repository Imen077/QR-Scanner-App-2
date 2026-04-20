import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ikutan/controllers/profile_controller.dart';
import 'package:ikutan/services/auth_services.dart';
import 'package:ikutan/utils/validator.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilePage extends StatelessWidget {
  EditProfilePage({super.key});

  // Pakai Get.find supaya controller yang sama di-share dengan ProfileTab
  final ProfileController _ctrl = Get.find<ProfileController>();
  final _authServices = Get.find<AuthServices>();
  final _formKey = GlobalKey<FormState>();

  static const _bg = Color(0xFF0D0D0D);
  static const _surface = Color(0xFF1A1A1A);
  static const _border = Color(0xFF2A2A2A);
  static const _accents = Color.fromARGB(255, 76, 255, 210);
  static const _textPrimary = Color(0xFFFFFFFF);
  static const _textSecondary = Color(0xFF888888);

  void _showImageSourceSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: _surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: _border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Change Profile Photo',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: _textPrimary,
              ),
            ),
            const SizedBox(height: 20),
            _sourceTile(
              icon: Icons.camera_alt_rounded,
              label: 'Take Photo',
              color: _accents,
              onTap: () {
                Get.back();
                _ctrl.pickImage(ImageSource.camera);
              },
            ),
            const SizedBox(height: 10),
            _sourceTile(
              icon: Icons.photo_library_rounded,
              label: 'Choose from Gallery',
              color: _accents,
              onTap: () {
                Get.back();
                _ctrl.pickImage(ImageSource.gallery);
              },
            ),
            const SizedBox(height: 10),
            Obx(() {
              final hasPicked = _ctrl.pickedImage.value != null;
              final hasNetwork =
                  _authServices.user.value?.avatar?.isNotEmpty == true;
              if (!hasPicked && !hasNetwork) return const SizedBox.shrink();
              return _sourceTile(
                icon: Icons.delete_rounded,
                label: 'Remove Photo',
                color: Colors.redAccent,
                onTap: () {
                  Get.back();
                  _ctrl.removeImage();
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _sourceTile({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: color, size: 22),
      ),
      title: Text(
        label,
        style: TextStyle(
          color: color == Colors.redAccent ? color : _textPrimary,
          fontWeight: FontWeight.w500,
          fontSize: 15,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: _border),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            _ctrl.resetForm();
            Get.back();
          },
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _border),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              size: 16,
              color: Colors.white,
            ),
          ),
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.pink,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        actions: [
          Obx(
            () => _ctrl.isLoading.value
                ? const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: _accents,
                        ),
                      ),
                    ),
                  )
                : TextButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _ctrl.saveProfile();
                      }
                    },
                    child: const Text(
                      'Save',
                      style: TextStyle(
                        color: _accents,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                  ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Obx(() {
                  final pickedFile = _ctrl.pickedImage.value;
                  final avatarUrl = _authServices.user.value?.avatar ?? '';
                  final userName = _authServices.user.value?.name;
                  return Stack(
                    children: [
                      GestureDetector(
                        onTap: () => _showImageSourceSheet(context),
                        child: Container(
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: _accents, width: 2.5),
                            color: _surface,
                          ),
                          child: ClipOval(
                            child: pickedFile != null
                                ? Image.file(pickedFile, fit: BoxFit.cover)
                                : avatarUrl.isNotEmpty
                                    ? Image.network(
                                        avatarUrl,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) =>
                                            _avatarInitials(userName),
                                      )
                                    : _avatarInitials(userName),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () => _showImageSourceSheet(context),
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: _accents,
                              shape: BoxShape.circle,
                              border: Border.all(color: _bg, width: 2.5),
                            ),
                            child: const Icon(
                              Icons.camera_alt_rounded,
                              size: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),
              const SizedBox(height: 8),
              Center(
                child: TextButton(
                  onPressed: () => _showImageSourceSheet(context),
                  child: const Text(
                    'Change Photo',
                    style: TextStyle(color: _accents, fontSize: 14),
                  ),
                ),
              ),

              const SizedBox(height: 24),
              _sectionLabel('Personal Info'),
              const SizedBox(height: 12),

              _buildField(
                controller: _ctrl.nameCtr,
                label: 'Full Name',
                icon: Icons.person_rounded,
                validator: Validator.validateName,
              ),
              const SizedBox(height: 12),
              _buildField(
                controller: _ctrl.emailCtr,
                label: 'Email',
                icon: Icons.email_rounded,
                readOnly: true,
                hint: 'Email cannot be changed',
              ),
              const SizedBox(height: 12),
              _buildField(
                controller: _ctrl.phoneCtr,
                label: 'Phone Number',
                icon: Icons.phone_rounded,
                keyboardType: TextInputType.phone,
              ),

              const SizedBox(height: 32),

              Obx(
                () => SizedBox(
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _ctrl.isLoading.value
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              _ctrl.saveProfile();
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _accents,
                      disabledBackgroundColor: _accents.withOpacity(0.4),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: _ctrl.isLoading.value
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.black,
                            ),
                          )
                        : const Text(
                            'Save Changes',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    bool readOnly = false,
    String? hint,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      validator: validator,
      keyboardType: keyboardType,
      style: TextStyle(
        color: readOnly ? _textSecondary : _textPrimary,
        fontSize: 15,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: const TextStyle(color: _textSecondary),
        hintStyle: const TextStyle(color: Color(0xFF555555), fontSize: 13),
        prefixIcon: Icon(
          icon,
          color: readOnly ? _textSecondary : _accents,
          size: 20,
        ),
        filled: true,
        fillColor: readOnly ? const Color(0xFF141414) : _surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.blueAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Widget _avatarInitials(String? name) {
    final initials = (name?.isNotEmpty == true)
        ? name!.trim().split(' ').map((e) => e[0]).take(2).join().toUpperCase()
        : '?';
    return Container(
      color: _accents.withOpacity(0.15),
      child: Center(
        child: Text(
          initials,
          style: const TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w800,
            color: _accents,
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: _textSecondary,
        letterSpacing: 1.2,
      ),
    );
  }
}