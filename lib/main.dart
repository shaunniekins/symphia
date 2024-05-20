// main.dart

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:symphia/controller/user_controller.dart';
import 'package:symphia/pages/home_page.dart';
import 'package:symphia/pages/main_page.dart';
import 'package:symphia/pages/persona/birthday_page.dart';
import 'package:symphia/pages/persona/name_page.dart';
import 'package:symphia/pages/settings_page.dart';
import 'package:symphia/pages/splash_screen.dart';
import 'package:symphia/services/database_service.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  Gemini.init(apiKey: dotenv.env['GEMINI_API_KEY']!);

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Request microphone permission
  var status = await Permission.microphone.request();
  if (status.isGranted) {
    Get.put(UserController());
    Get.put(DatabaseService());
    runApp(
      GetMaterialApp(
        initialRoute: '/',
        getPages: [
          GetPage(name: '/', page: () => const SplashScreen()),
          GetPage(name: '/home', page: () => HomePage()),
          GetPage(name: '/settings', page: () => const SettingsPage()),
          GetPage(name: '/main', page: () => const MainPage()),
          GetPage(name: '/name', page: () => const NamePage()),
          GetPage(name: '/birthday', page: () => const BirthdayPage())
        ],
        // theme: ThemeData(
        //   primarySwatch: Colors.grey,
        //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
        //   visualDensity: VisualDensity.adaptivePlatformDensity,
        // ),
      ),
    );
  } else {
    print('Microphone permission not granted');
  }
}
