// main.dart

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:symphia/pages/home_page.dart';
import 'package:symphia/pages/main_page.dart';
import 'package:symphia/pages/splash_screen.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  Gemini.init(apiKey: dotenv.env['GEMINI_API_KEY']!);

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Request microphone permission
  var status = await Permission.microphone.request();
  if (status.isGranted) {
    runApp(
      GetMaterialApp(
        initialRoute: '/',
        getPages: [
          GetPage(name: '/', page: () => SplashScreen()),
          GetPage(name: '/home', page: () => HomePage()),
          GetPage(name: '/main', page: () => const MainPage()),
        ],
      ),
    );
  } else {
    print('Microphone permission not granted');
  }
}
