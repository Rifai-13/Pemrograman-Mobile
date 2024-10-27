import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modul3/app/modules/home/views/home_view.dart';
import 'package:modul3/app/modules/register/views/register_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/modules/login/views/login_view.dart';
import 'auth_controller.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Get.putAsync(() async => await SharedPreferences.getInstance());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final AuthController _authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Modul 3',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/register',
      getPages: [
        GetPage(name: '/register', page: () => RegisterView()),
        GetPage(name: '/login', page: () => LoginView()),
        GetPage(name: '/home', page: () => HomeView()),
      ],
    );
  }
}
