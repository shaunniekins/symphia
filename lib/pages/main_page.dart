// main_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:symphia/controller.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Get.toNamed('/settings');
            },
          ),
        ],
      ),
      body: Obx(() => ListView.builder(
            itemCount: controller.chatHistory.length,
            itemBuilder: (context, index) {
              final message = controller.chatHistory[index];

              return ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.red,
                ),
                title: Text(
                  message,
                  style: const TextStyle(color: Colors.white),
                ),
              );
            },
          )),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        onPressed: () async {
          await controller.stopSpeaking();
          controller.onListen();
        },
        child: Obx(() => Icon(
            controller.isListening.value ? Icons.mic_none : Icons.mic_off)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
    );
  }
}
