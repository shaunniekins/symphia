// splash_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:symphia/pages/home_page.dart';
import 'package:symphia/pages/main_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

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
      // User is signed in, navigate to MainPage with a fade transition
      Get.offAll(
        () => const MainPage(),
        transition: Transition.fade,
        duration: const Duration(seconds: 1),
        curve: Curves.easeInOut,
      );
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
