// main_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:symphia/controller.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
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
