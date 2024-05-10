import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:symphia/controller.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        home: AnimatedSplashScreen(
      splashIconSize: 150,
      splash: ClipOval(
        child: Image.asset(
          'assets/images/symphia-logo.jpeg',
          fit: BoxFit.cover,
        ),
      ),
      nextScreen: const Home(),
    ));
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  final controller = Get.put(Controller());

  @override
  void initState() {
    super.initState();

    controller.flutterTts.setErrorHandler((msg) {
      print("TTS Error: $msg");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GeminiResponseTypeView(
        builder: (context, child, response, loading) {
          if (loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (response != null) {
            return Markdown(
              data: response,
              selectable: true,
            );
          } else {
            // Idle state
            return Center(
              child: Obx(
                () => controller.isListening.value
                    ? const CircularProgressIndicator()
                    : const SizedBox(),
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.onListen();
        },
        child: Obx(() =>
            Icon(controller.isListening.value ? Icons.mic : Icons.mic_off)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
    );
  }
}
