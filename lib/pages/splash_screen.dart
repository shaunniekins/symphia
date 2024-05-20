// splash_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:symphia/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:symphia/pages/main_page.dart';
import 'package:symphia/pages/persona/name_page.dart';
import 'package:symphia/services/database_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkUserAuthState();
  }

  Future<void> checkUserAuthState() async {
    final user = FirebaseAuth.instance.currentUser;
    await Future.delayed(const Duration(seconds: 2));

    if (user != null) {
      // User is signed in, check if user data exists in Firestore
      final databaseService = DatabaseService();
      final userProfileStream = databaseService.getUser();
      final userProfileSnapshot = await userProfileStream.first;

      if (userProfileSnapshot != null) {
        // User data exists in Firestore, navigate to HomePage with a fade transition
        Get.offAll(
          () => const MainPage(),
          transition: Transition.fade,
          duration: const Duration(seconds: 1),
          curve: Curves.easeInOut,
        );
      } else {
        // User data does not exist in Firestore, navigate to NamePage with a fade transition
        Get.offAll(
          () => const NamePage(),
          transition: Transition.fade,
          duration: const Duration(seconds: 1),
          curve: Curves.easeInOut,
        );
      }
    } else {
      // User is not signed in, navigate to HomePage with a fade transition
      Get.offAll(
        () => HomePage(),
        transition: Transition.fade,
        duration: const Duration(seconds: 1),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment:
            CrossAxisAlignment.center, // Center the children horizontally
        children: [
          Expanded(
            child: ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.purple, Colors.deepPurple],
              ).createShader(bounds),
              child: Center(
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: SvgPicture.asset('assets/images/symphia-logo.svg'),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 25.0),
            child: ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.purple, Colors.deepPurple],
              ).createShader(bounds),
              child: const Center(
                child: Text(
                  'symphia',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
