import 'dart:math';
import 'package:audio_wave/audio_wave.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Controller extends GetxController {
  RxBool isListening = false.obs;
  RxString text = ''.obs;
}

Widget audioWaveWidget({
  required Controller controller,
  required AnimationController animationController,
}) {
  final random = Random();

  return Obx(
    () => Center(
      child: controller.isListening.value
          ? AnimatedBuilder(
              animation: animationController,
              builder: (context, child) {
                return AudioWave(
                  height: 100,
                  width: MediaQuery.of(context).size.width * 0.8,
                  spacing: 2.5,
                  bars: List.generate(
                    20,
                    (index) => AudioWaveBar(
                      heightFactor: random.nextDouble(),
                      color: controller.text.value.isNotEmpty
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                );
              },
            )
          : const SizedBox(),
    ),
  );
}
