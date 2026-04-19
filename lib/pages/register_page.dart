import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ikutan/controllers/auth_controller.dart';
import 'package:ikutan/utils/const.dart';
import 'package:ikutan/utils/helper.dart';
import 'package:ikutan/utils/validator.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  final _controller = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Obx(
            () => Form(
              key: _controller.registerFormKey,
              child: Column(
                children: [
                  Text(
                    "Welcome to ${Const.appName}",
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  Text(
                    'Register to Create an Account',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    validator: Validator.validateName,
                    controller: _controller.nameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Name',
                    ),
                    onTapOutside: Helper.onTapOutside,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.name,
                    autofillHints: const [AutofillHints.name],
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    validator: Validator.validateEmail,
                    controller: _controller.emailController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                    onTapOutside: Helper.onTapOutside,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: const [AutofillHints.email],
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    validator: Validator.validatePassword,
                    controller: _controller.passwordController,
                    obscureText: _controller.isObscure.value,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _controller.isObscure.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: _controller.toggleObscure,
                      ),
                    ),
                    onTapOutside: Helper.onTapOutside,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.visiblePassword,
                    autofillHints: const [AutofillHints.password],
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    validator: (value) => Validator.validateConfirmPassword(
                      value,
                      _controller.passwordController.text,
                    ),
                    controller: _controller.confirmPasswordController,
                    obscureText: _controller.isObscureConfirm.value,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Confirm Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _controller.isObscure.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: _controller.toggleObscureConfirm,
                      ),
                    ),
                    onTapOutside: Helper.onTapOutside,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.visiblePassword,
                    autofillHints: const [AutofillHints.password],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _controller.isLoading.value
                        ? null
                        : _controller.register,
                    child: const Text('Register'),
                  ),
                  const SizedBox(height: 20),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Already have an account? ',
                          style: TextStyle(color: Colors.white),
                        ),
                        TextSpan(
                          text: 'Sign In',
                          style: TextStyle(color: Colors.blue),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => Get.back(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
