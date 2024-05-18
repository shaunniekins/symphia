// main_page.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
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

  Future<void> _signOut() async {
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
    Get.offAllNamed('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.deepPurple, size: 30),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: const Text('Home'),
              onTap: () {
                Get.offAllNamed('/home');
              },
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () {
                _signOut();
              },
            ),
          ],
        ),
      ),
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
