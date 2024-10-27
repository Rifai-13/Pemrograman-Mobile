import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../auth_controller.dart';

class LoginView extends StatefulWidget {
  @override
  State<LoginView> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginView> {
  // Instansiasi AuthController menggunakan Get.put
  final AuthController _authController = Get.put(AuthController());

  // Controllers untuk menangani input email dan password
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Dispose controller saat widget dihapus dari widget tree
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // TextField untuk input email
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            // TextField untuk input password, dengan fitur obscureText
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 16),

            // Tombol login yang menampilkan loading jika proses berlangsung
            Obx(() {
              return ElevatedButton(
                onPressed: _authController.isLoading.value
                    ? null
                    : () {
                        // Proses login saat tombol ditekan
                        _authController.loginUser(
                          _emailController.text,
                          _passwordController.text,
                        );
                      },
                // Menampilkan indikator loading jika isLoading bernilai true
                child: _authController.isLoading.value
                    ? CircularProgressIndicator()
                    : Text('Login'),
              );
            }),
          ],
        ),
      ),
    );
  }
}
