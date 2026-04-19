import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ikutan/services/auth_services.dart';
import 'package:ikutan/utils/helper.dart';

class ProfileTab extends StatelessWidget {
  ProfileTab({super.key});

  final _authServices = Get.find<AuthServices>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 24,
                    horizontal: 16,
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 36,
                        child: Icon(Icons.person, size: 36),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _authServices.user.value!.name!,
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      Text(
                        _authServices.user.value!.email!,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Chip(
                        label: Text(_authServices.user.value!.role!),
                        backgroundColor:
                            _authServices.user.value!.role == "admin"
                            ? Colors.red.shade700
                            : Colors.green.shade700,
                        labelStyle: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: Colors.white),
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.all(4),
                      ),
                      const Divider(height: 20),
                      Text('Joined ON'),
                      Text(
                        Helper.formatDate(_authServices.user.value!.createdAt!),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => _authServices.logout(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade700,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
